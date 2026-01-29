@echo off
REM 跨设备上下文恢复脚本
REM 用途: 到达新设备后，快速拉取所有更改

echo ========================================
echo 跨设备上下文恢复
echo ========================================
echo.

REM 1. 拉取 K_Kiro_Work
echo [1/2] 拉取 K_Kiro_Work...
git pull
if errorlevel 1 (
    echo ❌ K_Kiro_Work 拉取失败！
    pause
    exit /b 1
)
echo ✅ K_Kiro_Work 拉取完成
echo.

REM 2. 拉取中央知识库
echo [2/2] 拉取中央知识库...
cd /d D:\G_GitHub\Kiro-Central-KB
git pull
if errorlevel 1 (
    echo ❌ 中央知识库拉取失败！
    cd /d %~dp0..
    pause
    exit /b 1
)
echo ✅ 中央知识库拉取完成
echo.

REM 返回原目录
cd /d %~dp0..

echo ========================================
echo ✅ 所有更新完成！
echo ========================================
echo.
echo 现在可以打开 Kiro，说"继续开发"来恢复上下文。
echo.
echo 或者使用以下提示词：
echo.
echo "我刚切换到另一台设备，请帮我恢复上下文：
echo 1. 读取今日总结
echo 2. 读取中央知识库相关讨论
echo 3. 告诉我当前状态和下一步"
echo.
pause
