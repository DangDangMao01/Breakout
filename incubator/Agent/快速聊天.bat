@echo off
chcp 65001 >nul
echo ========================================
echo AI 助手（支持网络搜索）
echo ========================================
echo.

cd /d "%~dp0"

python quick_chat.py

pause
