@echo off
chcp 65001 >nul
echo ========================================
echo Ollama 快速测试（无需安装依赖）
echo ========================================
echo.

cd /d "%~dp0"
python test_ollama_simple.py

echo.
pause
