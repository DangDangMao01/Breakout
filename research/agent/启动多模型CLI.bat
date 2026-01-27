@echo off
chcp 65001 >nul
echo ========================================
echo 多模型 AI 助手 CLI
echo 支持切换和对比多个模型
echo ========================================
echo.

cd /d "%~dp0"

echo 正在启动...
echo.

python cli_multi_model.py

pause
