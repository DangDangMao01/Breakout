#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
测试 GitLab Webhook 服务器
模拟 GitLab Push Hook 发送测试数据
"""

import requests
import json

# Webhook 服务器地址
WEBHOOK_URL = "http://localhost:5000/gitlab-webhook"

# 模拟 GitLab Push Hook 数据
test_data = {
    "object_kind": "push",
    "event_name": "push",
    "project": {
        "id": 1,
        "name": "测试项目",
        "path_with_namespace": "grouptwogame/测试文件"
    },
    "user_name": "王新来",
    "user_email": "wangxinlai@huixuanjiasu.com",
    "commits": [
        {
            "id": "abc123def456",
            "message": "测试 Webhook 通知\n\n这是一条测试提交信息，包含中文。",
            "timestamp": "2026-01-23T20:00:00+08:00",
            "url": "https://gitlab.huixuanjiasu.com/grouptwogame/grouptowart_hb/-/commit/abc123",
            "author": {
                "name": "王新来",
                "email": "wangxinlai@huixuanjiasu.com"
            }
        }
    ]
}

def test_webhook():
    """测试 Webhook"""
    print("=" * 60)
    print("测试 GitLab Webhook 服务器")
    print("=" * 60)
    print(f"Webhook URL: {WEBHOOK_URL}")
    print(f"项目: {test_data['project']['path_with_namespace']}")
    print(f"提交人: {test_data['user_name']} <{test_data['user_email']}>")
    print(f"提交信息: {test_data['commits'][0]['message']}")
    print("-" * 60)
    
    try:
        print("\n[发送] 正在发送测试数据...")
        headers = {
            "X-Gitlab-Event": "Push Hook",
            "Content-Type": "application/json"
        }
        
        response = requests.post(
            WEBHOOK_URL,
            json=test_data,
            headers=headers,
            timeout=10
        )
        
        print(f"[响应] 状态码: {response.status_code}")
        print(f"[响应] 内容: {response.text}")
        
        if response.status_code == 200:
            result = response.json()
            if result.get('status') == 'success':
                print("\n" + "=" * 60)
                print("✅ 测试成功！")
                print(f"通知人数: {result.get('notified', 0)}/{result.get('total', 0)}")
                print("=" * 60)
                print("\n请检查飞书是否收到通知！")
            else:
                print("\n" + "=" * 60)
                print("⚠️ 测试失败")
                print(f"原因: {result.get('reason', '未知')}")
                print("=" * 60)
        else:
            print("\n" + "=" * 60)
            print("❌ 服务器返回错误")
            print("=" * 60)
            
    except requests.exceptions.ConnectionError:
        print("\n" + "=" * 60)
        print("❌ 连接失败")
        print("=" * 60)
        print("\n可能原因：")
        print("1. Webhook 服务器未启动")
        print("2. 服务器地址错误")
        print("\n解决方案：")
        print("1. 运行 '启动Webhook服务器.bat'")
        print("2. 检查 WEBHOOK_URL 是否正确")
        
    except Exception as e:
        print("\n" + "=" * 60)
        print("❌ 测试失败")
        print("=" * 60)
        print(f"错误: {e}")

def test_health():
    """测试健康检查"""
    health_url = "http://localhost:5000/health"
    print("\n" + "=" * 60)
    print("测试健康检查")
    print("=" * 60)
    print(f"URL: {health_url}")
    
    try:
        response = requests.get(health_url, timeout=5)
        print(f"状态码: {response.status_code}")
        print(f"响应: {response.text}")
        
        if response.status_code == 200:
            print("\n✅ 服务器运行正常")
        else:
            print("\n⚠️ 服务器状态异常")
            
    except requests.exceptions.ConnectionError:
        print("\n❌ 无法连接到服务器")
        print("请先启动 Webhook 服务器")
    except Exception as e:
        print(f"\n❌ 错误: {e}")

if __name__ == "__main__":
    # 先测试健康检查
    test_health()
    
    # 再测试 Webhook
    print("\n")
    test_webhook()
    
    print("\n" + "=" * 60)
    print("测试完成")
    print("=" * 60)
    input("\n按回车键退出...")
