#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
飞书 API 测试脚本
用于验证应用权限和发送测试消息
"""

import os
import json
import requests

# 从环境变量读取
APP_ID = os.environ.get('FEISHU_APP_ID')
APP_SECRET = os.environ.get('FEISHU_APP_SECRET')
TEST_EMAIL = "wangxinlai@huixuanjiasu.com"  # 测试邮箱

def get_tenant_access_token():
    """获取飞书机器人的访问令牌"""
    print("步骤 1: 获取 Access Token...")
    
    if not APP_ID or not APP_SECRET:
        print("❌ 错误: 未配置环境变量")
        print("   请先设置: FEISHU_APP_ID 和 FEISHU_APP_SECRET")
        return None
    
    print(f"   App ID: {APP_ID}")
    print(f"   App Secret: {APP_SECRET[:10]}...")
        
    url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
    body = {"app_id": APP_ID, "app_secret": APP_SECRET}
    
    try:
        r = requests.post(url, json=body)
        data = r.json()
        
        if data.get('code') == 0:
            token = data.get("tenant_access_token")
            print(f"✅ Token 获取成功: {token[:20]}...")
            return token
        else:
            print(f"❌ Token 获取失败:")
            print(f"   错误码: {data.get('code')}")
            print(f"   错误信息: {data.get('msg')}")
            return None
    except Exception as e:
        print(f"❌ 请求失败: {e}")
        return None

def get_user_id_by_email(email, token):
    """通过邮箱查找飞书用户的 User ID"""
    print(f"\n步骤 2: 查找用户 ({email})...")
    
    url = "https://open.feishu.cn/open-apis/contact/v3/users/batch_get_id?user_id_type=open_id"
    body = {"emails": [email]}
    headers = {
        "Authorization": "Bearer " + token,
        "Content-Type": "application/json"
    }
    
    try:
        r = requests.post(url, json=body, headers=headers)
        data = r.json()
        
        if data.get('code') == 0:
            user_list = data.get('data', {}).get('user_list', [])
            if user_list:
                user_info = user_list[0]
                user_id = user_info.get('user_id')
                print(f"✅ 用户查找成功:")
                print(f"   User ID: {user_id}")
                print(f"   Email: {user_info.get('email')}")
                return user_id
            else:
                print(f"❌ 未找到该邮箱对应的用户")
                print(f"   可能原因:")
                print(f"   1. 邮箱不是飞书企业邮箱")
                print(f"   2. 用户未加入飞书企业")
                print(f"   3. 应用权限不足")
                return None
        else:
            print(f"❌ 查找用户失败:")
            print(f"   错误码: {data.get('code')}")
            print(f"   错误信息: {data.get('msg')}")
            return None
    except Exception as e:
        print(f"❌ 请求失败: {e}")
        return None

def send_message(user_id, token):
    """发送测试消息"""
    print(f"\n步骤 3: 发送测试消息...")
    
    url = "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id"
    
    # 构建消息内容
    text = "🎉 飞书通知测试成功！\n\n这是来自 GitLab 美术资源通知系统的测试消息。"
    content = json.dumps({"text": text})
    
    body = {
        "receive_id": user_id,
        "msg_type": "text",
        "content": content
    }
    
    headers = {
        "Authorization": "Bearer " + token,
        "Content-Type": "application/json"
    }
    
    try:
        r = requests.post(url, json=body, headers=headers)
        data = r.json()
        
        if data.get('code') == 0:
            print(f"✅ 消息发送成功！")
            print(f"   请检查飞书是否收到消息")
            return True
        else:
            print(f"❌ 消息发送失败:")
            print(f"   错误码: {data.get('code')}")
            print(f"   错误信息: {data.get('msg')}")
            return False
    except Exception as e:
        print(f"❌ 请求失败: {e}")
        return False

def main():
    print("=" * 50)
    print("飞书 API 测试")
    print("=" * 50)
    print()
    
    # 1. 获取 Token
    token = get_tenant_access_token()
    if not token:
        print("\n❌ 测试失败: 无法获取 Token")
        return
    
    # 2. 查找用户
    user_id = get_user_id_by_email(TEST_EMAIL, token)
    if not user_id:
        print("\n❌ 测试失败: 无法找到用户")
        return
    
    # 3. 发送消息
    success = send_message(user_id, token)
    
    print()
    print("=" * 50)
    if success:
        print("✅ 测试完成: 所有功能正常")
    else:
        print("❌ 测试失败: 请检查错误信息")
    print("=" * 50)

if __name__ == "__main__":
    main()
