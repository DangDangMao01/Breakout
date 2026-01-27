@echo off
chcp 65001 >nul
echo ============================================================
echo 飞书秘钥测试工具
echo ============================================================
echo.

REM 提示用户输入秘钥
echo 请输入你的飞书应用秘钥：
echo.
set /p APP_ID="APP_ID: "
set /p APP_SECRET="APP_SECRET: "

echo.
echo ============================================================
echo 开始测试...
echo ============================================================
echo.

REM 设置环境变量
set FEISHU_APP_ID=%APP_ID%
set FEISHU_APP_SECRET=%APP_SECRET%

REM 运行测试脚本
python test_feishu_token.py

echo.
echo ============================================================
echo 测试完成！
echo ============================================================
echo.
echo 如果看到 [成功] Token 获取成功，说明秘钥正确
echo 如果看到 [错误]，请检查秘钥是否正确
echo.
pause
