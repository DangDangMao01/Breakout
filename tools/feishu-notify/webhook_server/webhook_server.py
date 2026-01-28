#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GitLab Webhook 服务器 - 飞书通知
接收 GitLab Push 事件，发送飞书通知
"""

from flask import Flask, request, jsonify
import requests
import json
import os

app = Flask(__name__)

# 飞书配置
FEISHU_APP_ID = os.environ.get('FEISHU_APP_ID', 'cli_a9e3400711fbdbcb')
FEISHU_APP_SECRET = os.environ.get('FEISHU_APP_SECRET', 'h61QXukkibdbO0wRRFxTkgppaLvcPQFS')

# 项目负责人配置（从 owners.json 读取）
OWNERS_FILE = os.path.join(os.path.dirname(__file__), '..', 'config', 'owners.json')

def load_owners():
    """加载项目负责人配置"""
    try:
        with open(OWNERS_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"[错误] 加载 owners.json 失败: {e}")
        return {}

def get_tenant_access_token():
    """获取飞书访问令牌"""
    url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
    body = {"app_id": FEISHU_APP_ID, "app_secret": FEISHU_APP_SECRET}
    try:
        r = requests.post(url, json=body)
        return r.json().get("tenant_access_token")
    except Exception as e:
        print(f"获取 Token 失败: {e}")
        return None

def get_user_id_by_email(email, token):
    """通过邮箱查找飞书用户 ID"""
    url = "https://open.feishu.cn/open-apis/contact/v3/users/batch_get_id?user_id_type=open_id"
    body = {"emails": [email]}
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    try:
        r = requests.post(url, json=body, headers=headers)
        data = r.json()
        if data.get('code') == 0 and data.get('data', {}).get('user_list'):
            return data['data']['user_list'][0].get('user_id')
    except Exception as e:
        print(f"查找用户失败: {e}")
    return None

def send_feishu_card(user_id, project_name, user_name, commit_message, commit_url, token):
    """发送飞书卡片消息"""
    card = {
        "config": {"wide_screen_mode": True},
        "header": {
            "title": {"tag": "plain_text", "content": "[美术资源更新提醒]"},
            "template": "blue"
        },
        "elements": [
            {
                "tag": "div",
                "fields": [
                    {"is_short": True, "text": {"tag": "lark_md", "content": f"**项目**\n{project_name}"}},
                    {"is_short": True, "text": {"tag": "lark_md", "content": f"**提交人**\n{user_name}"}}
                ]
            },
            {
                "tag": "div",
                "text": {"tag": "lark_md", "content": f"**提交信息**\n{commit_message}"}
            },
            {
                "tag": "action",
                "actions": [
                    {
                        "tag": "button",
                        "text": {"tag": "plain_text", "content": "查看变更"},
                        "url": commit_url,
                        "type": "primary"
                    }
                ]
            },
            {
                "tag": "note",
                "elements": [
                    {"tag": "plain_text", "content": "请及时拉取最新资源！"}
                ]
            }
        ]
    }
    
    url = "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id"
    body = {
        "receive_id": user_id,
        "msg_type": "interactive",
        "content": json.dumps(card)
    }
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    
    try:
        r = requests.post(url, json=body, headers=headers)
        result = r.json()
        return result.get('code') == 0
    except Exception as e:
        print(f"发送消息失败: {e}")
        return False

def find_owner_by_project(project_path, owners):
    """根据项目路径查找负责人"""
    for key, emails in owners.items():
        if key.startswith('_'):  # 跳过注释
            continue
        if key in project_path:
            if isinstance(emails, str):
                return [emails]
            elif isinstance(emails, list):
                return emails
    return None

@app.route('/gitlab-webhook', methods=['POST'])
def gitlab_webhook():
    """处理 GitLab Webhook"""
    try:
        data = request.json
        
        # 提取信息
        event_name = request.headers.get('X-Gitlab-Event')
        
        # 只处理 Push 事件
        if event_name != 'Push Hook':
            return jsonify({'status': 'ignored', 'reason': f'Event {event_name} not supported'}), 200
        
        project_name = data['project']['path_with_namespace']
        user_name = data['user_name']
        user_email = data['user_email']
        
        # 获取最新的提交信息
        if data['commits']:
            commit = data['commits'][-1]  # 最新的提交
            commit_message = commit['message']
            commit_url = commit['url']
        else:
            return jsonify({'status': 'ignored', 'reason': 'No commits'}), 200
        
        print(f"[Webhook] 项目: {project_name}")
        print(f"[Webhook] 提交人: {user_name} <{user_email}>")
        print(f"[Webhook] 提交信息: {commit_message}")
        
        # 查找项目负责人
        owners = load_owners()
        owner_emails = find_owner_by_project(project_name, owners)
        
        if not owner_emails:
            print(f"[警告] 未找到项目 {project_name} 的负责人")
            return jsonify({'status': 'error', 'reason': 'No owner found'}), 200
        
        # 获取飞书 Token
        token = get_tenant_access_token()
        if not token:
            return jsonify({'status': 'error', 'reason': 'Failed to get token'}), 500
        
        # 发送通知给所有负责人
        success_count = 0
        for owner_email in owner_emails:
            user_id = get_user_id_by_email(owner_email, token)
            if user_id:
                if send_feishu_card(user_id, project_name, user_name, commit_message, commit_url, token):
                    print(f"[成功] 通知已发送给 {owner_email}")
                    success_count += 1
                else:
                    print(f"[失败] 发送通知给 {owner_email} 失败")
            else:
                print(f"[失败] 找不到用户 {owner_email}")
        
        return jsonify({
            'status': 'success',
            'notified': success_count,
            'total': len(owner_emails)
        }), 200
        
    except Exception as e:
        print(f"[错误] 处理 Webhook 失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'status': 'error', 'reason': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    """健康检查"""
    return jsonify({'status': 'ok'}), 200

if __name__ == '__main__':
    print("=" * 60)
    print("GitLab Webhook 服务器启动")
    print("=" * 60)
    print(f"监听地址: http://0.0.0.0:5000")
    print(f"Webhook URL: http://your-server-ip:5000/gitlab-webhook")
    print("=" * 60)
    app.run(host='0.0.0.0', port=5000, debug=True)
