import os
import sys
import json
import requests
import subprocess

# =================配置区=================
# 这些变量会从 GitLab 的 CI/CD 设置里读取，不需要改代码
APP_ID = os.environ.get('FEISHU_APP_ID')
APP_SECRET = os.environ.get('FEISHU_APP_SECRET')
# =======================================

def get_tenant_access_token():
    """获取飞书机器人的访问令牌"""
    if not APP_ID or not APP_SECRET:
        print("错误: 未配置 FEISHU_APP_ID 或 FEISHU_APP_SECRET 环境变量")
        return None
        
    url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
    body = {"app_id": APP_ID, "app_secret": APP_SECRET}
    try:
        r = requests.post(url, json=body)
        r.raise_for_status()
        return r.json().get("tenant_access_token")
    except Exception as e:
        print(f"获取 Token 失败: {e}")
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
                print(f"未找到该邮箱对应的用户: {email}")
    except Exception as e:
        print(f"查找用户失败: {e}")
    return None

def send_message(user_id, text, token):
    """发送私聊消息"""
    url = "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id"
    # 构建卡片消息可能会更好看，但为了稳定先用纯文本
    content = json.dumps({"text": text})
    body = {
        "receive_id": user_id,
        "msg_type": "text",
        "content": content
    }
    headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json"}
    try:
        r = requests.post(url, json=body, headers=headers)
        if r.json().get('code') == 0:
            return True
        else:
            print(f"发送失败: {r.text}")
    except Exception as e:
        print(f"发送请求错误: {e}")
    return False

def get_changed_files():
    """获取本次提交变动的文件列表"""
    before_sha = os.environ.get('CI_COMMIT_BEFORE_SHA')
    current_sha = os.environ.get('CI_COMMIT_SHA')
    
    # 如果是首次提交或新建分支，before_sha 可能是 0000...
    if not before_sha or before_sha == '0000000000000000000000000000000000000000':
        cmd = f"git diff-tree --no-commit-id --name-only -r {current_sha}"
    else:
        cmd = f"git diff --name-only {before_sha} {current_sha}"
        
    try:
        output = subprocess.check_output(cmd, shell=True).decode('utf-8')
        return [f for f in output.strip().split('\n') if f]
    except Exception as e:
        print(f"获取 Git 变动失败: {e}")
        return []

def main():
    print(">>> 开始检查美术资源变动...")
    
    # 1. 获取变动文件
    changed_files = get_changed_files()
    if not changed_files:
        print("没有检测到文件变动。")
        return

    # 2. 读取负责人名单
    try:
        with open('owners.json', 'r', encoding='utf-8') as f:
            owners = json.load(f)
    except FileNotFoundError:
        print("错误: 找不到 owners.json 配置文件")
        return
    except json.JSONDecodeError:
        print("错误: owners.json 格式不正确")
        return

    # 3. 获取飞书 Token
    token = get_tenant_access_token()
    if not token:
        return

    # 4. 分析变动并通知
    notified_users = set()
    user_name = os.environ.get('GITLAB_USER_NAME', '美术同事')
    
    for file_path in changed_files:
        # 获取第一级文件夹名字 (即项目名)
        parts = file_path.split('/')
        if not parts:
            continue
        project_name = parts[0]
        
        # 检查该项目是否有配置负责人
        if project_name in owners:
            email = owners[project_name]
            
            # 避免重复通知同一个人
            if email in notified_users:
                continue
                
            print(f"检测到项目 [{project_name}] 变动，准备通知: {email}")
            user_id = get_user_id_by_email(email, token)
            
            if user_id:
                msg = f"【美术资源更新提醒】\n📁 项目：{project_name}\n👤 提交人：{user_name}\n🚀 请及时拉取最新资源！"
                if send_message(user_id, msg, token):
                    print(f"--> 通知发送成功！")
                    notified_users.add(email)
            else:
                print(f"--> 无法获取 UserID，跳过通知。")

if __name__ == "__main__":
    main()
