"""
飞书甘特图任务自动提醒脚本
功能：读取飞书知识库中的多维表格，自动提醒即将到期的任务
"""

import os
import json
import requests
from datetime import datetime, timedelta

# 飞书配置
APP_ID = os.environ.get('FEISHU_APP_ID')
APP_SECRET = os.environ.get('FEISHU_APP_SECRET')

# 多维表格配置
APP_TOKEN = "GZjDwxrcgiJWOCk90Cxcwpirn0c"  # 从 URL 中提取的 wiki_token
TABLE_ID = "tblowyYECiCfFbJi"  # 从 URL 中提取的 table_id

# 提醒配置
REMIND_DAYS_BEFORE = 3  # 提前几天提醒
CHECK_OVERDUE = True  # 是否检查逾期任务

def get_tenant_access_token():
    """获取飞书访问令牌"""
    if not APP_ID or not APP_SECRET:
        print("错误: 未配置 FEISHU_APP_ID 或 FEISHU_APP_SECRET")
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

def get_bitable_records(token):
    """读取多维表格数据"""
    url = f"https://open.feishu.cn/open-apis/bitable/v1/apps/{APP_TOKEN}/tables/{TABLE_ID}/records"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    try:
        # 分页读取所有记录
        all_records = []
        page_token = None
        
        while True:
            params = {"page_size": 100}
            if page_token:
                params["page_token"] = page_token
                
            r = requests.get(url, headers=headers, params=params)
            data = r.json()
            
            if data.get('code') != 0:
                print(f"读取表格失败: {data.get('msg')}")
                return []
            
            records = data.get('data', {}).get('items', [])
            all_records.extend(records)
            
            # 检查是否还有下一页
            page_token = data.get('data', {}).get('page_token')
            if not page_token:
                break
        
        print(f"成功读取 {len(all_records)} 条记录")
        return all_records
        
    except Exception as e:
        print(f"读取表格失败: {e}")
        return []

def parse_date(date_value):
    """解析日期字段"""
    if not date_value:
        return None
    
    # 飞书日期字段通常是时间戳（毫秒）
    if isinstance(date_value, (int, float)):
        return datetime.fromtimestamp(date_value / 1000)
    
    # 或者是字符串格式
    if isinstance(date_value, str):
        try:
            return datetime.strptime(date_value, "%Y-%m-%d")
        except:
            return None
    
    return None

def get_user_id_by_email(email, token):
    """通过邮箱查找飞书用户 ID"""
    url = "https://open.feishu.cn/open-apis/contact/v3/users/batch_get_id?user_id_type=open_id"
    body = {"emails": [email]}
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    try:
        r = requests.post(url, json=body, headers=headers)
        data = r.json()
        if data.get('code') == 0 and data.get('data', {}).get('user_list'):
            user_info = data['data']['user_list'][0]
            return user_info.get('user_id')
    except Exception as e:
        print(f"查找用户失败: {e}")
    
    return None

def send_message(user_id, text, token):
    """发送飞书消息"""
    url = "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id"
    content = json.dumps({"text": text})
    body = {
        "receive_id": user_id,
        "msg_type": "text",
        "content": content
    }
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    try:
        r = requests.post(url, json=body, headers=headers)
        return r.json().get('code') == 0
    except Exception as e:
        print(f"发送消息失败: {e}")
        return False

def check_tasks(records, token):
    """检查任务并发送提醒"""
    today = datetime.now().date()
    remind_date = today + timedelta(days=REMIND_DAYS_BEFORE)
    
    upcoming_tasks = []
    overdue_tasks = []
    
    for record in records:
        fields = record.get('fields', {})
        
        # 提取字段（需要根据实际表格结构调整）
        task_name = fields.get('任务名称', '未命名任务')
        deadline = parse_date(fields.get('截止日期'))
        owner = fields.get('负责人')  # 可能是用户对象或邮箱
        status = fields.get('状态', '')
        
        if not deadline:
            continue
        
        deadline_date = deadline.date()
        
        # 检查即将到期的任务
        if deadline_date <= remind_date and deadline_date >= today:
            days_left = (deadline_date - today).days
            upcoming_tasks.append({
                'name': task_name,
                'deadline': deadline_date,
                'days_left': days_left,
                'owner': owner,
                'status': status
            })
        
        # 检查逾期任务
        if CHECK_OVERDUE and deadline_date < today and status != '已完成':
            days_overdue = (today - deadline_date).days
            overdue_tasks.append({
                'name': task_name,
                'deadline': deadline_date,
                'days_overdue': days_overdue,
                'owner': owner,
                'status': status
            })
    
    # 发送提醒
    if upcoming_tasks:
        print(f"\n发现 {len(upcoming_tasks)} 个即将到期的任务")
        for task in upcoming_tasks:
            send_task_reminder(task, token, 'upcoming')
    
    if overdue_tasks:
        print(f"\n发现 {len(overdue_tasks)} 个逾期任务")
        for task in overdue_tasks:
            send_task_reminder(task, token, 'overdue')
    
    if not upcoming_tasks and not overdue_tasks:
        print("\n没有需要提醒的任务")

def send_task_reminder(task, token, reminder_type):
    """发送任务提醒"""
    owner = task['owner']
    
    # 如果负责人是邮箱字符串
    if isinstance(owner, str) and '@' in owner:
        user_id = get_user_id_by_email(owner, token)
    # 如果负责人是用户对象（需要根据实际情况调整）
    elif isinstance(owner, dict):
        user_id = owner.get('id') or owner.get('open_id')
    else:
        print(f"无法识别负责人格式: {owner}")
        return
    
    if not user_id:
        print(f"无法找到用户: {owner}")
        return
    
    # 构建消息
    if reminder_type == 'upcoming':
        message = f"""【任务到期提醒】
📋 任务: {task['name']}
⏰ 截止日期: {task['deadline']}
⚠️ 还剩 {task['days_left']} 天
📊 当前状态: {task['status']}

请及时完成任务！"""
    else:  # overdue
        message = f"""【任务逾期通知】
📋 任务: {task['name']}
⏰ 截止日期: {task['deadline']}
🚨 已逾期 {task['days_overdue']} 天
📊 当前状态: {task['status']}

请尽快处理！"""
    
    if send_message(user_id, message, token):
        print(f"✓ 已通知: {task['name']} → {owner}")
    else:
        print(f"✗ 通知失败: {task['name']} → {owner}")

def main():
    print("=" * 50)
    print("飞书甘特图任务自动提醒")
    print(f"执行时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    # 1. 获取访问令牌
    token = get_tenant_access_token()
    if not token:
        return
    
    # 2. 读取表格数据
    records = get_bitable_records(token)
    if not records:
        print("未读取到任何记录")
        return
    
    # 3. 检查任务并发送提醒
    check_tasks(records, token)
    
    print("\n" + "=" * 50)
    print("执行完成")
    print("=" * 50)

if __name__ == "__main__":
    main()
