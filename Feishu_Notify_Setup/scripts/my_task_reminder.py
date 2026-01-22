"""
个人任务提醒助手
功能：每天提醒你自己的任务
"""

import os
import json
import requests
from datetime import datetime, timedelta

# 飞书配置
APP_ID = os.environ.get('FEISHU_APP_ID')
APP_SECRET = os.environ.get('FEISHU_APP_SECRET')

# 任务配置文件
TASKS_FILE = "my_tasks.json"

def get_tenant_access_token():
    """获取飞书访问令牌"""
    if not APP_ID or not APP_SECRET:
        print("错误: 未配置飞书应用凭证")
        return None
        
    url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
    body = {"app_id": APP_ID, "app_secret": APP_SECRET}
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

def send_message(user_id, text, token):
    """发送飞书消息"""
    url = "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id"
    content = json.dumps({"text": text})
    body = {"receive_id": user_id, "msg_type": "text", "content": content}
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    
    try:
        r = requests.post(url, json=body, headers=headers)
        return r.json().get('code') == 0
    except Exception as e:
        print(f"发送消息失败: {e}")
        return False

def load_tasks():
    """读取任务列表"""
    try:
        with open(TASKS_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"错误: 找不到 {TASKS_FILE}")
        return None
    except json.JSONDecodeError:
        print(f"错误: {TASKS_FILE} 格式不正确")
        return None

def check_my_tasks():
    """检查我的任务"""
    data = load_tasks()
    if not data:
        return
    
    tasks = data.get('tasks', [])
    my_email = data.get('my_email')
    
    today = datetime.now().date()
    
    # 分类任务
    upcoming = []  # 即将到期
    overdue = []   # 已逾期
    today_start = []  # 今天开始
    
    for task in tasks:
        deadline_str = task.get('deadline')
        if not deadline_str:
            continue
        
        deadline = datetime.strptime(deadline_str, "%Y-%m-%d").date()
        days_left = (deadline - today).days
        status = task.get('status', '')
        
        # 即将到期（3 天内）
        if 0 <= days_left <= 3 and status != '已完成':
            upcoming.append({
                'name': task['name'],
                'deadline': deadline,
                'days_left': days_left,
                'priority': task.get('priority', '中')
            })
        
        # 已逾期
        if days_left < 0 and status != '已完成':
            overdue.append({
                'name': task['name'],
                'deadline': deadline,
                'days_overdue': abs(days_left),
                'priority': task.get('priority', '中')
            })
    
    # 构建消息
    if not upcoming and not overdue:
        message = f"【个人任务提醒】早上好！\n\n✅ 太棒了！你没有即将到期或逾期的任务。\n\n继续保持！💪"
    else:
        message = f"【个人任务提醒】早上好！\n\n⏰ 今天是 {today.strftime('%Y年%m月%d日')}\n"
        
        if upcoming:
            message += f"\n📋 即将到期的任务（{len(upcoming)} 个）：\n"
            for task in sorted(upcoming, key=lambda x: x['days_left']):
                emoji = "🔴" if task['priority'] == '高' else "🟡" if task['priority'] == '中' else "🟢"
                if task['days_left'] == 0:
                    message += f"{emoji} {task['name']}（今天到期！）\n"
                else:
                    message += f"{emoji} {task['name']}（还剩 {task['days_left']} 天）\n"
        
        if overdue:
            message += f"\n🚨 逾期任务（{len(overdue)} 个）：\n"
            for task in sorted(overdue, key=lambda x: x['days_overdue'], reverse=True):
                emoji = "🔴" if task['priority'] == '高' else "🟡"
                message += f"{emoji} {task['name']}（逾期 {task['days_overdue']} 天）\n"
        
        message += "\n加油！💪"
    
    # 发送消息
    token = get_tenant_access_token()
    if not token:
        return
    
    user_id = get_user_id_by_email(my_email, token)
    if not user_id:
        print(f"无法找到用户: {my_email}")
        return
    
    if send_message(user_id, message, token):
        print("✓ 任务提醒已发送")
    else:
        print("✗ 任务提醒发送失败")

def main():
    print("=" * 50)
    print("个人任务提醒助手")
    print(f"执行时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    check_my_tasks()
    
    print("=" * 50)
    print("执行完成")
    print("=" * 50)

if __name__ == "__main__":
    main()
