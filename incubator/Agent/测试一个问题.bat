@echo off
chcp 65001 >nul
echo ========================================
echo 测试搜索功能
echo ========================================
echo.

cd /d "%~dp0"

echo 问题: Blender 4.0 有什么新功能？
echo.
echo 正在搜索并生成回答...
echo.

python -c "from quick_chat import answer_with_search; print(answer_with_search('Blender 4.0 有什么新功能？'))"

echo.
echo ========================================
echo 测试完成
echo ========================================
pause
