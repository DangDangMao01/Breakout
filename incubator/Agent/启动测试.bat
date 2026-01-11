@echo off
chcp 65001 >nul
echo ========================================
echo DCC 智能体系统 - 快速测试
echo ========================================
echo.

echo [1] 测试 Ollama 连接...
python examples/test_ollama.py

echo.
echo ========================================
echo 测试完成
echo ========================================
pause
