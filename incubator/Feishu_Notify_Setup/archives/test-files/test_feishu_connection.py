"""
飞书 API 连接测试脚本
用于排查飞书通知问题
"""
import os
import requests
import json

def test_feishu_connection():
    """测试飞书 API 连接"""
    print("=" * 60)
    print("飞书 API 连接测试")
    print("=" * 60)
    
    # 1. 检查环境变量
    print("\n[步骤 1] 检查环境变量...")
    app_id = os.environ.get('FEISHU_APP_ID')
    app_secret = os.environ.get('FEISHU_APP_SECRET')
    
    if not app_id:
        print("[错误] 未找到 FEISHU_APP_ID 环境变量")
        print("[提示] 请设置: set FEISHU_APP_ID=your_app_id")
        return False
    
    if not app_secret:
        print("[错误] 未找到 FEISHU_APP_SECRET 环境变量")
        print("[提示] 请设置: set FEISHU_APP_SECRET=your_app_secret")
        return False
    
    print(f"[成功] FEISHU_APP_ID: {app_id[:10]}...")
    print(f"[成功] FEISHU_APP_SECRET: {app_secret[:10]}...")
    
    # 2. 获取 Token
    print("\n[步骤 2] 获取飞书访问令牌...")
    url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
    body = {"app_id": app_id, "app_secret": app_secret}
    
    try:
        r = requests.post(url, json=body, timeout=10)
        r.raise_for_status()
        data = r.json()
        
        if data.get('code') != 0:
            print(f"[错误] 获取 Token 失败: {data.get('msg')}")
            print(f"[详情] {json.dumps(data, indent=2, ensure_ascii=False)}")
            return False
        
        token = data.get("tenant_access_token")
        print(f"[成功] Token 获取成功: {token[:20]}...")
        
    except requests.exceptions.RequestException as e:
        print(f"[错误] 网络请求失败: {e}")
        return False
    
    # 3. 测试查找用户
    print("\n[步骤 3] 测试查找用户...")
    test_email = "wangxinlai@huixuanjiasu.com"
    print(f"[测试] 查找邮箱: {test_email}")
    
    url = "https://open.feishu.cn/open-apis/contact/v3/users/batch_get_id?user_id_type=open_id"
    body = {"emails": [test_email]}
    headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json"}
    
    try:
        r = requests.post(url, json=body, headers=headers, timeout=10)
        data = r.json()
        
        if data.get('code') != 0:
            print(f"[错误] 查找用户失败: {data.get('msg')}")
            print(f"[详情] {json.dumps(data, indent=2, ensure_ascii=False)}")
            return False
        
        user_list = data.get('data', {}).get('user_list', [])
        if not user_list:
            print(f"[错误] 未找到用户: {test_email}")
            print("[提示] 请检查:")
            print("  1. 邮箱是否正确")
            print("  2. 用户是否在飞书中")
            print("  3. 飞书应用是否有权限查询用户")
            return False
        
        user_id = user_list[0].get('user_id')
        print(f"[成功] 找到用户 ID: {user_id}")
        
    except requests.exceptions.RequestException as e:
        print(f"[错误] 网络请求失败: {e}")
        return False
    
    # 4. 测试发送消息
    print("\n[步骤 4] 测试发送消息...")
    print(f"[测试] 发送测试消息给: {test_email}")
    
    url = "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id"
    content = json.dumps({"text": "[测试] 飞书通知系统连接测试成功！"})
    body = {
        "receive_id": user_id,
        "msg_type": "text",
        "content": content
    }
    headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json"}
    
    try:
        r = requests.post(url, json=body, headers=headers, timeout=10)
        data = r.json()
        
        if data.get('code') != 0:
            print(f"[错误] 发送消息失败: {data.get('msg')}")
            print(f"[详情] {json.dumps(data, indent=2, ensure_ascii=False)}")
            print("\n[常见原因]:")
            print("  1. 飞书应用没有'发送消息'权限")
            print("  2. 用户未添加机器人为好友")
            print("  3. 应用未发布或未启用")
            return False
        
        print(f"[成功] 消息发送成功！")
        print(f"[提示] 请检查飞书是否收到测试消息")
        
    except requests.exceptions.RequestException as e:
        print(f"[错误] 网络请求失败: {e}")
        return False
    
    # 5. 总结
    print("\n" + "=" * 60)
    print("[完成] 所有测试通过！")
    print("=" * 60)
    print("\n[结论] 飞书 API 连接正常，问题可能在:")
    print("  1. GitLab CI 环境变量未配置")
    print("  2. 项目路径匹配失败")
    print("  3. owners.json 配置错误")
    print("\n[建议] 查看 GitLab CI 日志确认具体问题")
    
    return True

if __name__ == "__main__":
    test_feishu_connection()
