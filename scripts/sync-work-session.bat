@echo off
REM 跨设备工作会话同步脚本
REM 用途: 离开当前设备前，快速同步所有更改

echo ========================================
echo 跨设备工作会话同步
echo ========================================
echo.

REM 1. 同步 K_Kiro_Work
echo [1/3] 同步 K_Kiro_Work...
git add .
git commit -m "Work session: %date% %time%"
git push
if errorlevel 1 (
    echo ❌ K_Kiro_Work 同步失败！
    pause
    exit /b 1
)
echo ✅ K_Kiro_Work 同步完成
echo.

REM 2. 同步到中央知识库
echo [2/3] 同步到中央知识库...
if exist "knowledge-base\notes\*.md" (
    xcopy /Y /I "knowledge-base\notes\*.md" "D:\G_GitHub\Kiro-Central-KB\notes\"
    echo ✅ notes 同步完成
)
if exist "knowledge-base\solutions\*.md" (
    xcopy /Y /I "knowledge-base\solutions\*.md" "D:\G_GitHub\Kiro-Central-KB\solutions\"
    echo ✅ solutions 同步完成
)
if exist "knowledge-base\discussions\*.md" (
    xcopy /Y /I "knowledge-base\discussions\*.md" "D:\G_GitHub\Kiro-Central-KB\discussions\"
    echo ✅ discussions 同步完成
)
echo.

REM 3. 提交中央知识库
echo [3/3] 提交中央知识库...
cd /d D:\G_GitHub\Kiro-Central-KB
git add .
git commit -m "Sync: K_Kiro_Work %date%"
git push
if errorlevel 1 (
    echo ❌ 中央知识库同步失败！
    cd /d %~dp0..
    pause
    exit /b 1
)
echo ✅ 中央知识库同步完成
echo.

REM 返回原目录
cd /d %~dp0..

echo ========================================
echo ✅ 所有同步完成！
echo ========================================
echo.
echo 现在可以安全地切换到其他设备了。
echo.
pause
