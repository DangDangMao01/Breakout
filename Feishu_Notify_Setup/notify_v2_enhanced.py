import os
import json
import requests

# 飞书配置
APP_ID = os.environ.get('FEISHU_APP_ID')
APP_SECRET = os.environ.get('FEISHU_APP_SECRET')

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
    except Exception as e:
        print(f"查找用户失败: {e}")
    return None

def send_card_message(user_id, project_name, user_name, commit_msg, commit_url, token):
    """发送卡片消息（更美观）"""
    card = {
        "config": {"wide_screen_mode": True},
        "header": {
            "title": {"tag": "plain_text", "content": "🎨 美术资源更新提醒"},
            "template": "blue"
        },
        "elements": [
            {
                "tag": "div",
                "fields": [
                    {"is_short": True, "text": {"tag": "lark_md", "content": f"**📁 项目**\n{project_name}"}},
                    {"is_short": True, "text": {"tag": "lark_md", "content": f"**👤 提交人**\n{user_name}"}}
                ]
            },
            {
                "tag": "div",
                "text": {"tag": "lark_md", "content": f"**💬 提交信息**\n{commit_msg}"}
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
        return r.json().get('code') == 0
    except Exception as e:
        print(f"发送卡片消息失败: {e}")
        return False

def send_message(user_id, text, token):
    """发送文本消息（备用方案）"""
    url = "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id"
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

def main():
    print(">>> 开始检查美术资源变动...")
    
    # 从环境变量获取提交信息
    commit_message = os.environ.get('CI_COMMIT_MESSAGE', '未知提交')
    user_name = os.environ.get('GITLAB_USER_NAME', '美术同事')
    project_path = os.environ.get('CI_PROJECT_PATH', '')
    commit_url = os.environ.get('CI_PROJECT_URL', '') + '/-/commit/' + os.environ.get('CI_COMMIT_SHA', '')
    
    print(f"提交信息: {commit_message}")
    print(f"提交人: {user_name}")
    print(f"项目路径: {project_path}")
    
    # 读取负责人名单
    try:
        with open('owners.json', 'r', encoding='utf-8') as f:
            owners = json.load(f)
    except FileNotFoundError:
        print("错误: 找不到 owners.json 配置文件")
        return
    except json.JSONDecodeError:
        print("错误: owners.json 格式不正确")
        return

    # 获取飞书 Token
    token = get_tenant_access_token()
    if not token:
        return

    # 通知测试文件的负责人
    test_email = owners.get("测试文件", "")
    if not test_email:
        print("未配置测试文件负责人")
        return
    
    print(f"准备通知: {test_email}")
    user_id = get_user_id_by_email(test_email, token)
    
    if user_id:
        # 尝试发送卡片消息
        if send_card_message(user_id, project_path, user_name, commit_message, commit_url, token):
            print("--> 卡片消息发送成功！")
        else:
            # 卡片失败，降级为文本消息
            msg = f"【美术资源更新提醒】\n📁 项目：{project_path}\n👤 提交人：{user_name}\n💬 提交信息：{commit_message}\n🔗 查看变更：{commit_url}"
            if send_message(user_id, msg, token):
                print("--> 文本消息发送成功！")
            else:
                print("--> 消息发送失败")
    else:
        print("--> 无法获取 UserID，跳过通知")

if __name__ == "__main__":
    main()
