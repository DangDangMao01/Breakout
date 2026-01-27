@echo off
chcp 65001 >nul
echo ========================================
echo 增强型 AI 助手 CLI
echo 支持网络搜索
echo ========================================
echo.

cd /d "%~dp0"

echo 正在启动...
echo.

python cli_enhanced.py

pause
