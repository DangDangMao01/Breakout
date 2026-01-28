#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GitLab CI 飞书通知脚本 - 优化版
避免中文编码问题，使用邮箱和时间戳
"""

import os
import json
import requests
import sys
from datetime import datetime

# 设置标准输出编码为 UTF-8
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# 飞书配置
APP_ID = os.environ.get('FEISHU_APP_ID')
APP_SECRET = os.environ.get('FEISHU_APP_SECRET')

def get_tenant_access_token():
    """获取飞书机器人的访问令牌"""
    if not APP_ID or not APP_SECRET:
        print("[ERROR] FEISHU_APP_ID or FEISHU_APP_SECRET not configured")
        return None
        
    url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
    body = {"app_id": APP_ID, "app_secret": APP_SECRET}
    try:
        r = requests.post(url, json=body)
        r.raise_for_status()
        return r.json().get("tenant_access_token")
    except Exception as e:
        print(f"[ERROR] Failed to get token: {e}")
        return None

def get_user_id_by_email(email, token):
    """通过邮箱查找飞书用户的 User ID"""
    url = "https://open.feishu.cn/open-apis/contact/v3/users/batch_get_id?user_id_type=open_id"
    body = {"emails": [email]}
    headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json"}
    try:
        r = requests.post(url, json=body, headers=headers)
        data = r.json()
        
        if data.get('code') == 0 and data.get('data', {}).get('user_list'):
            user_info = data['data']['user_list'][0]
            if 'user_id' in user_info:
                return user_info['user_id']
        else:
            print(f"[ERROR] User not found - Code: {data.get('code')}, Message: {data.get('msg')}")
    except Exception as e:
        print(f"[ERROR] Failed to find user: {e}")
    return None

def find_owner_by_project(project_path, owners):
    """
    根据项目路径查找对应的负责人邮箱（支持多人）
    """
    # 跳过注释字段
    valid_owners = {k: v for k, v in owners.items() if not k.startswith('_')}
    
    # 1. 精确匹配：项目路径包含完整的 key
    for key, emails in valid_owners.items():
        if key in project_path:
            print(f"[MATCH] Exact match: '{key}' in project path")
            # 统一转换为列表
            if isinstance(emails, str):
                return [emails]
            elif isinstance(emails, list):
                return emails
    
    # 2. 模糊匹配：去掉项目前缀后匹配
    for key, emails in valid_owners.items():
        # 去掉项目前缀（如 "Y_遇水发财" -> "遇水发财"）
        clean_key = key.split('_', 1)[-1] if '_' in key else key
        
        if clean_key in project_path:
            print(f"[MATCH] Fuzzy match: '{clean_key}' (from '{key}') in project path")
            # 统一转换为列表
            if isinstance(emails, str):
                return [emails]
            elif isinstance(emails, list):
                return emails
    
    # 3. 未找到
    print(f"[WARNING] No owner found for project: '{project_path}'")
    return None

def send_card_message(user_id, project_name, user_info, update_time, commit_url, token):
    """发送卡片消息（优化版 - 避免中文编码问题）"""
    card = {
        "config": {"wide_screen_mode": True},
        "header": {
            "title": {"tag": "plain_text", "content": "[Art Resource Update Reminder]"},
            "template": "blue"
        },
        "elements": [
            {
                "tag": "div",
                "fields": [
                    {"is_short": True, "text": {"tag": "lark_md", "content": f"**Project**\n{project_name}"}},
                    {"is_short": True, "text": {"tag": "lark_md", "content": f"**Submitter**\n{user_info}"}}
                ]
            },
            {
                "tag": "div",
                "text": {"tag": "lark_md", "content": f"**Update Time**\n{update_time}"}
            },
            {
                "tag": "action",
                "actions": [
                    {
                        "tag": "button",
                        "text": {"tag": "plain_text", "content": "View Changes"},
                        "url": commit_url,
                        "type": "primary"
                    }
                ]
            },
            {
                "tag": "note",
                "elements": [
                    {"tag": "plain_text", "content": "Please pull the latest resources!"}
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
    headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json"}
    
    try:
        r = requests.post(url, json=body, headers=headers)
        result = r.json()
        
        if result.get('code') == 0:
            return True
        else:
            print(f"[ERROR] Failed to send - Code: {result.get('code')}, Message: {result.get('msg')}")
            return False
    except Exception as e:
        print(f"[ERROR] Failed to send card: {e}")
        return False

def main():
    print("=" * 60)
    print(">>> GitLab CI Feishu Notification v3.2 (Optimized)")
    print("=" * 60)
    
    # 获取环境变量
    project_path = os.environ.get('CI_PROJECT_PATH', 'unknown/project')
    commit_sha = os.environ.get('CI_COMMIT_SHA', '')
    commit_url = os.environ.get('CI_PROJECT_URL', '') + '/-/commit/' + commit_sha
    
    # 获取提交人信息（优先使用邮箱，避免中文乱码）
    user_email = os.environ.get('GITLAB_USER_EMAIL', '')
    user_login = os.environ.get('GITLAB_USER_LOGIN', '')
    
    if user_email:
        user_info = user_email
        print(f"[INFO] Submitter: {user_email}")
    elif user_login:
        user_info = user_login
        print(f"[INFO] Submitter: {user_login}")
    else:
        user_info = 'Unknown User'
        print(f"[WARNING] Submitter unknown")
    
    # 使用时间戳代替中文提交信息（避免乱码）
    update_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    print(f"[INFO] Project: {project_path}")
    print(f"[INFO] Update Time: {update_time}")
    print(f"[INFO] Commit URL: {commit_url}")
    print("-" * 60)
    
    # 读取负责人名单
    try:
        with open('owners.json', 'r', encoding='utf-8') as f:
            owners = json.load(f)
        print(f"[OK] Loaded owners.json, {len(owners)} entries")
    except FileNotFoundError:
        print("[ERROR] owners.json not found")
        return
    except json.JSONDecodeError:
        print("[ERROR] owners.json format error")
        return

    # 查找项目对应的负责人邮箱
    print(f"\n[SEARCH] Finding owner for project '{project_path}'...")
    owner_emails = find_owner_by_project(project_path, owners)
    
    if not owner_emails:
        print(f"\n[WARNING] No owner found for project '{project_path}'")
        print("[TIP] Please add configuration in owners.json")
        return
    
    print(f"[OK] Found {len(owner_emails)} owner(s):")
    for email in owner_emails:
        print(f"  - {email}")
    print("-" * 60)

    # 获取飞书 Token
    print("\n[TOKEN] Getting Feishu access token...")
    token = get_tenant_access_token()
    if not token:
        print("[ERROR] Failed to get token")
        return
    print("[OK] Token obtained")

    # 循环发送通知给所有负责人
    success_count = 0
    fail_count = 0
    
    for owner_email in owner_emails:
        print(f"\n[SEARCH] Finding Feishu user: {owner_email}")
        user_id = get_user_id_by_email(owner_email, token)
        
        if not user_id:
            print(f"[ERROR] User not found: {owner_email}")
            fail_count += 1
            continue
        
        print(f"[OK] User ID: {user_id}")
        print("-" * 60)

        # 发送通知
        print(f"\n[SEND] Sending notification to {owner_email}...")
        
        if send_card_message(user_id, project_path, user_info, update_time, commit_url, token):
            print(f"[OK] Notification sent successfully!")
            success_count += 1
        else:
            print(f"[ERROR] Failed to send notification")
            fail_count += 1
    
    # 总结
    print("\n" + "=" * 60)
    print(f"[COMPLETE] Notification process finished")
    print(f"[SUCCESS] {success_count} recipient(s)")
    if fail_count > 0:
        print(f"[FAILED] {fail_count} recipient(s)")
    print("=" * 60)

if __name__ == "__main__":
    main()
