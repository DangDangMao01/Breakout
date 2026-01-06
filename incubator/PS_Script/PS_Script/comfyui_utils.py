"""
ComfyUI 工具模块 - 提供连接检测、WebSocket 进度反馈等功能
"""
import json
import urllib.request
import urllib.error
import os
import threading
import time

# 配置文件路径
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SETTINGS_FILE = os.path.join(SCRIPT_DIR, "settings.json")

def load_settings():
    """加载配置文件"""
    default_settings = {
        "comfyui": {
            "url": "http://127.0.0.1:8188",
            "timeout": 300
        },
        "models": {
            "default": "全能 dreamshaper_8.safetensors",
            "available": []
        },
        "generation": {
            "default_width": 512,
            "default_height": 512,
            "steps": 20,
            "cfg": 7,
            "sampler": "euler_ancestral",
            "scheduler": "normal",
            "denoise": 0.85
        },
        "inpaint": {
            "grow_mask_by": 6,
            "denoise": 0.85
        },
        "negative_prompt": "bad quality, blurry, ugly, deformed, worst quality"
    }
    
    if os.path.exists(SETTINGS_FILE):
        try:
            with open(SETTINGS_FILE, 'r', encoding='utf-8') as f:
                user_settings = json.load(f)
                # 合并配置
                for key, value in user_settings.items():
                    if isinstance(value, dict) and key in default_settings:
                        default_settings[key].update(value)
                    else:
                        default_settings[key] = value
        except Exception as e:
            print(f"警告: 加载配置文件失败 - {e}")
    
    return default_settings

def save_settings(settings):
    """保存配置文件"""
    try:
        with open(SETTINGS_FILE, 'w', encoding='utf-8') as f:
            json.dump(settings, f, indent=4, ensure_ascii=False)
        return True
    except Exception as e:
        print(f"保存配置失败: {e}")
        return False

class ComfyUIConnection:
    """ComfyUI 连接管理器"""
    
    def __init__(self, url=None):
        self.settings = load_settings()
        self.url = url or self.settings["comfyui"]["url"]
        self.timeout = self.settings["comfyui"]["timeout"]
        self._ws = None
        self._progress_callback = None
    
    def check_connection(self):
        """检查 ComfyUI 是否可连接"""
        try:
            req = urllib.request.Request(f"{self.url}/system_stats", method='GET')
            req.add_header('Accept', 'application/json')
            response = urllib.request.urlopen(req, timeout=5)
            data = json.loads(response.read().decode())
            return True, data
        except urllib.error.URLError as e:
            return False, f"无法连接到 ComfyUI: {e.reason}"
        except Exception as e:
            return False, f"连接错误: {str(e)}"
    
    def wait_for_comfyui(self, max_wait=60, interval=2):
        """等待 ComfyUI 启动"""
        print(f"等待 ComfyUI 启动 ({self.url})...")
        start_time = time.time()
        
        while time.time() - start_time < max_wait:
            connected, info = self.check_connection()
            if connected:
                print("ComfyUI 已连接!")
                return True
            time.sleep(interval)
            print(f"  重试中... ({int(time.time() - start_time)}s)")
        
        print(f"超时: ComfyUI 在 {max_wait} 秒内未响应")
        return False
    
    def get_available_models(self):
        """获取可用的模型列表"""
        try:
            req = urllib.request.Request(f"{self.url}/object_info/CheckpointLoaderSimple")
            response = urllib.request.urlopen(req, timeout=10)
            data = json.loads(response.read().decode())
            
            if "CheckpointLoaderSimple" in data:
                inputs = data["CheckpointLoaderSimple"]["input"]["required"]
                if "ckpt_name" in inputs:
                    return inputs["ckpt_name"][0]
            return []
        except Exception as e:
            print(f"获取模型列表失败: {e}")
            return []
    
    def get_queue_status(self):
        """获取队列状态"""
        try:
            req = urllib.request.Request(f"{self.url}/queue")
            response = urllib.request.urlopen(req, timeout=5)
            data = json.loads(response.read().decode())
            return {
                "running": len(data.get("queue_running", [])),
                "pending": len(data.get("queue_pending", []))
            }
        except Exception as e:
            return {"error": str(e)}


class ProgressTracker:
    """进度追踪器 - 使用轮询方式"""
    
    def __init__(self, comfyui_url, prompt_id):
        self.url = comfyui_url
        self.prompt_id = prompt_id
        self.progress = 0
        self.status = "waiting"
        self.current_node = ""
        self._stop = False
        self._thread = None
        self._callback = None
    
    def start(self, callback=None):
        """开始追踪进度"""
        self._callback = callback
        self._stop = False
        self._thread = threading.Thread(target=self._poll_progress, daemon=True)
        self._thread.start()
    
    def stop(self):
        """停止追踪"""
        self._stop = True
        if self._thread:
            self._thread.join(timeout=2)
    
    def _poll_progress(self):
        """轮询进度"""
        while not self._stop:
            try:
                # 检查历史记录
                req = urllib.request.Request(f"{self.url}/history/{self.prompt_id}")
                response = urllib.request.urlopen(req, timeout=5)
                history = json.loads(response.read().decode())
                
                if self.prompt_id in history:
                    self.status = "completed"
                    self.progress = 100
                    if self._callback:
                        self._callback(self.progress, self.status, "完成")
                    break
                
                # 检查队列状态
                req = urllib.request.Request(f"{self.url}/queue")
                response = urllib.request.urlopen(req, timeout=5)
                queue = json.loads(response.read().decode())
                
                running = queue.get("queue_running", [])
                pending = queue.get("queue_pending", [])
                
                # 检查是否在运行中
                for item in running:
                    if len(item) > 1 and item[1] == self.prompt_id:
                        self.status = "running"
                        if self._callback:
                            self._callback(self.progress, self.status, "生成中...")
                        break
                
                # 检查是否在等待中
                for i, item in enumerate(pending):
                    if len(item) > 1 and item[1] == self.prompt_id:
                        self.status = "pending"
                        if self._callback:
                            self._callback(0, self.status, f"队列中 (位置 {i+1})")
                        break
                
            except Exception as e:
                pass
            
            time.sleep(0.5)
    
    def wait_completion(self, timeout=300):
        """等待完成"""
        start = time.time()
        while time.time() - start < timeout:
            if self.status == "completed":
                return True
            time.sleep(0.5)
        return False


def print_progress_bar(progress, status, message=""):
    """打印进度条"""
    bar_length = 30
    filled = int(bar_length * progress / 100)
    bar = '█' * filled + '░' * (bar_length - filled)
    print(f"\r[{bar}] {progress:3.0f}% - {message}", end='', flush=True)
    if progress >= 100:
        print()  # 换行
