@echo off
chcp 65001 >nul
echo ========================================
echo 开始下载 Qwen 2.5 32B 模型
echo ========================================
echo.
echo 模型大小：约 19GB
echo 预计时间：10-30 分钟
echo.
echo 下载中，请勿关闭窗口...
echo.

C:\Users\dangd\AppData\Local\Programs\Ollama\ollama.exe pull qwen2.5:32b

echo.
echo ========================================
echo 下载完成！
echo ========================================
echo.
echo 验证模型列表：
C:\Users\dangd\AppData\Local\Programs\Ollama\ollama.exe list
echo.
echo 下一步：运行 "启动测试.bat" 测试连接
echo.
pause
