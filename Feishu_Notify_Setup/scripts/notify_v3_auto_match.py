import os
import json
import requests
import sys

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
        print(f"[调试] 请求 URL: {url}")
        print(f"[调试] 请求 Body: {body}")
        r = requests.post(url, json=body, headers=headers)
        data = r.json()
        print(f"[调试] 响应状态码: {r.status_code}")
        print(f"[调试] 响应数据: {data}")
        
        if data.get('code') == 0 and data.get('data', {}).get('user_list'):
            user_info = data['data']['user_list'][0]
            if 'user_id' in user_info:
                return user_info['user_id']
        else:
            print(f"[错误] 查找用户失败 - 错误码: {data.get('code')}, 错误信息: {data.get('msg')}")
    except Exception as e:
        print(f"[异常] 查找用户失败: {e}")
    return None

def find_owner_by_project(project_path, owners):
    """
    根据项目路径查找对应的负责人邮箱（支持多人）
    支持两种匹配方式：
    1. 精确匹配：项目路径包含完整的 key
    2. 模糊匹配：项目路径包含 key 的一部分
    
    返回值：
    - 单个邮箱字符串 → 返回 [email]
    - 邮箱数组 → 返回 [email1, email2, ...]
    - 未找到 → 返回 None
    
    例如：
    - 项目路径: grouptwogame/Y_遇水发财
    - owners.json: {"Y_遇水发财": ["email1@xxx.com", "email2@xxx.com"]}
    - 匹配成功 → 返回 ["email1@xxx.com", "email2@xxx.com"]
    """
    # 跳过注释字段
    valid_owners = {k: v for k, v in owners.items() if not k.startswith('_')}
    
    # 1. 精确匹配：项目路径包含完整的 key
    for key, emails in valid_owners.items():
        if key in project_path:
            print(f"[匹配] 精确匹配: 项目路径包含 '{key}'")
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
            print(f"[匹配] 模糊匹配: 项目路径包含 '{clean_key}' (来自 '{key}')")
            # 统一转换为列表
            if isinstance(emails, str):
                return [emails]
            elif isinstance(emails, list):
                return emails
    
    # 3. 未找到
    print(f"[未找到] 项目路径 '{project_path}' 没有对应的负责人")
    return None

def send_card_message(user_id, project_name, user_name, commit_msg, commit_url, token):
    """发送卡片消息（更美观）"""
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
                "text": {"tag": "lark_md", "content": f"**提交信息**\n{commit_msg}"}
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
    headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json"}
    
    try:
        print(f"[调试] 发送卡片消息到用户: {user_id}")
        r = requests.post(url, json=body, headers=headers)
        result = r.json()
        print(f"[调试] 发送响应状态码: {r.status_code}")
        print(f"[调试] 发送响应数据: {result}")
        
        if result.get('code') == 0:
            return True
        else:
            print(f"[错误] 发送失败 - 错误码: {result.get('code')}, 错误信息: {result.get('msg')}")
            return False
    except Exception as e:
        print(f"[异常] 发送卡片消息失败: {e}")
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
    print("=" * 60)
    print(">>> 美术资源通知系统 v3.1 - 多人通知版")
    print("=" * 60)
    
    # 从环境变量获取提交信息（Windows 环境需要处理编码）
    def get_env_utf8(key, default=''):
        """从环境变量获取 UTF-8 编码的值"""
        value = os.environ.get(key, default)
        if sys.platform == 'win32' and value:
            try:
                # 尝试将 GBK 错误解码的字符串重新编码为正确的 UTF-8
                value = value.encode('latin1').decode('utf-8')
            except:
                pass
        return value
    
    commit_message = get_env_utf8('CI_COMMIT_MESSAGE', '未知提交')
    user_name = get_env_utf8('GITLAB_USER_NAME', '未知用户')
    project_path = get_env_utf8('CI_PROJECT_PATH', '未知项目')
    commit_sha = os.environ.get('CI_COMMIT_SHA', '')
    commit_url = os.environ.get('CI_PROJECT_URL', '') + '/-/commit/' + commit_sha
    
    # 测试模式：如果设置了 TEST_MODE=true，强制通知测试邮箱
    test_mode = os.environ.get('TEST_MODE', 'false').lower() == 'true'
    test_email = os.environ.get('TEST_EMAIL', 'wangxinlai@huixuanjiasu.com')
    
    print(f"[提交信息] {commit_message}")
    print(f"[提交人] {user_name}")
    print(f"[项目路径] {project_path}")
    print(f"[提交链接] {commit_url}")
    
    if test_mode:
        print(f"[测试模式] 启用")
        print(f"[测试邮箱] {test_email}")
    
    print("-" * 60)
    
    # 读取负责人名单
    try:
        with open('owners.json', 'r', encoding='utf-8') as f:
            owners = json.load(f)
        print(f"[成功] 加载 owners.json，共 {len(owners)} 个配置")
    except FileNotFoundError:
        print("[错误] 找不到 owners.json 配置文件")
        return
    except json.JSONDecodeError:
        print("[错误] owners.json 格式不正确")
        return

    # 查找项目对应的负责人邮箱
    print(f"\n[查找] 正在查找项目 '{project_path}' 的负责人...")
    
    # 测试模式：强制使用测试邮箱
    if test_mode:
        owner_emails = [test_email]
        print(f"[测试模式] 使用测试邮箱 {test_email}")
    else:
        owner_emails = find_owner_by_project(project_path, owners)
        
        if not owner_emails:
            print(f"\n[警告] 未找到项目 '{project_path}' 的负责人配置")
            print("[提示] 请在 owners.json 中添加配置")
            print(f'   "项目名称": ["email@huixuanjiasu.com"]')
            print(f'\n   或多人通知：')
            print(f'   "项目名称": ["email1@huixuanjiasu.com", "email2@huixuanjiasu.com"]')
            return
        
        print(f"[成功] 找到 {len(owner_emails)} 个负责人:")
        for email in owner_emails:
            print(f"  - {email}")
    print("-" * 60)

    # 获取飞书 Token
    print("\n[Token] 正在获取飞书访问令牌...")
    token = get_tenant_access_token()
    if not token:
        print("[错误] 获取令牌失败，无法发送通知")
        return
    print("[成功] 令牌获取成功")

    # 循环发送通知给所有负责人
    success_count = 0
    fail_count = 0
    
    for owner_email in owner_emails:
        print(f"\n[查找] 正在查找飞书用户 ID: {owner_email}")
        user_id = get_user_id_by_email(owner_email, token)
        
        if not user_id:
            print(f"[错误] 无法找到邮箱 {owner_email} 对应的飞书用户")
            print("[提示] 请检查邮箱是否正确，或用户是否在飞书中")
            fail_count += 1
            continue
        
        print(f"[成功] 找到用户 ID: {user_id}")
        print("-" * 60)

        # 发送通知
        print(f"\n[发送] 正在发送通知给 {owner_email}...")
        
        # 尝试发送卡片消息
        if send_card_message(user_id, project_path, user_name, commit_message, commit_url, token):
            print(f"[成功] 卡片消息发送成功！")
            success_count += 1
        else:
            # 卡片失败，降级为文本消息
            print("[警告] 卡片消息发送失败，尝试文本消息...")
            msg = f"【美术资源更新提醒】\n项目：{project_path}\n提交人：{user_name}\n提交信息：{commit_message}\n查看变更：{commit_url}\n请及时拉取最新资源！"
            if send_message(user_id, msg, token):
                print(f"[成功] 文本消息发送成功！")
                success_count += 1
            else:
                print(f"[错误] 消息发送失败")
                fail_count += 1
    
    # 总结
    print("\n" + "=" * 60)
    print(f"[完成] 通知发送完成")
    print(f"[成功] {success_count} 人")
    if fail_count > 0:
        print(f"[失败] {fail_count} 人")
    print("=" * 60)

if __name__ == "__main__":
    main()
