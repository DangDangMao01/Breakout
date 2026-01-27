import os
import requests

# 从环境变量读取（或者直接填写测试）
APP_ID = os.environ.get('FEISHU_APP_ID', '填写你的APP_ID')
APP_SECRET = os.environ.get('FEISHU_APP_SECRET', '填写你的APP_SECRET')

print("=" * 60)
print(">>> 飞书秘钥测试")
print("=" * 60)
print(f"APP_ID: {APP_ID[:10]}..." if len(APP_ID) > 10 else f"APP_ID: {APP_ID}")
print(f"APP_SECRET: {APP_SECRET[:10]}..." if len(APP_SECRET) > 10 else f"APP_SECRET: {APP_SECRET}")
print("-" * 60)

# 测试获取 Token
url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
body = {"app_id": APP_ID, "app_secret": APP_SECRET}

try:
    print("\n[测试] 正在获取 Token...")
    response = requests.post(url, json=body)
    data = response.json()
    
    print(f"[响应] HTTP 状态码: {response.status_code}")
    print(f"[响应] 返回数据: {data}")
    
    if data.get('code') == 0:
        token = data.get('tenant_access_token')
        print(f"\n[成功] Token 获取成功！")
        print(f"[Token] {token[:20]}...")
        
        # 测试查找用户
        print("\n" + "-" * 60)
        print("[测试] 正在查找用户...")
        test_email = "wangxinlai@huixuanjiasu.com"
        
        user_url = "https://open.feishu.cn/open-apis/contact/v3/users/batch_get_id?user_id_type=open_id"
        user_body = {"emails": [test_email]}
        headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json"}
        
        user_response = requests.post(user_url, json=user_body, headers=headers)
        user_data = user_response.json()
        
        print(f"[响应] {user_data}")
        
        if user_data.get('code') == 0:
            print(f"\n[成功] 用户查找成功！")
            if user_data.get('data', {}).get('user_list'):
                user_info = user_data['data']['user_list'][0]
                print(f"[用户] {user_info}")
            else:
                print(f"[警告] 未找到用户 {test_email}")
        else:
            print(f"\n[错误] 用户查找失败")
            print(f"[错误码] {user_data.get('code')}")
            print(f"[错误信息] {user_data.get('msg')}")
    else:
        print(f"\n[错误] Token 获取失败")
        print(f"[错误码] {data.get('code')}")
        print(f"[错误信息] {data.get('msg')}")
        
except Exception as e:
    print(f"\n[异常] {e}")

print("\n" + "=" * 60)
