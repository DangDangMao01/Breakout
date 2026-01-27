@echo off
chcp 65001 >nul
echo ========================================
echo 自动更新知识库
echo ========================================
echo.

cd /d "%~dp0"

echo [1] 安装依赖...
pip install -r requirements-web.txt -q

echo.
echo [2] 开始更新知识库...
python workflows/auto_update_kb.py

echo.
echo ========================================
echo 更新完成
echo ========================================
echo.
pause
