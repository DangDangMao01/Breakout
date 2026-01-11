@echo off
chcp 65001 >nul
echo ========================================
echo Ollama 对话测试
echo ========================================
echo.
echo 模型：Qwen 2.5 32B
echo.
echo 输入你的问题，输入 /bye 退出
echo.

C:\Users\dangd\AppData\Local\Programs\Ollama\ollama.exe run qwen2.5:32b

pause
