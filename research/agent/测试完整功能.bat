@echo off
chcp 65001 >nul
echo ========================================
echo 测试完整功能（包含 ChromaDB）
echo ========================================
echo.
echo 测试问题：Blender 4.0 有什么新功能？
echo.
python cli_enhanced.py --command "Blender 4.0 有什么新功能？"
echo.
echo ========================================
echo 测试完成！
echo ========================================
pause
