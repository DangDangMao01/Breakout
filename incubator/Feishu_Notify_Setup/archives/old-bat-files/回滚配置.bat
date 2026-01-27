@echo off
chcp 65001 >nul
echo ========================================
echo   飞书通知系统 - 回滚配置
echo ========================================
echo.

:: 检查是否有管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 需要管理员权限
    echo 请右键点击此文件，选择"以管理员身份运行"
    pause
    exit /b 1
)

echo [警告] 即将回滚到备份配置
echo.
echo 按任意键继续，或关闭窗口取消...
pause >nul
echo.

echo [步骤 1/2] 查找最新备份...
for /f "delims=" %%i in ('dir /b /o-d "D:\HuiXuanJiaSu\I_IAA_Work\.gitlab-ci.yml.backup.*" 2^>nul') do (
    set "BACKUP_FILE=%%i"
    goto :found
)

echo [错误] 未找到备份文件
pause
exit /b 1

:found
echo [找到] %BACKUP_FILE%
echo.

echo [步骤 2/2] 恢复备份...
copy /Y "D:\HuiXuanJiaSu\I_IAA_Work\%BACKUP_FILE%" "D:\HuiXuanJiaSu\I_IAA_Work\.gitlab-ci.yml" >nul
if %errorLevel% equ 0 (
    echo [成功] 配置已回滚
) else (
    echo [错误] 回滚失败
    pause
    exit /b 1
)
echo.

echo ========================================
echo   回滚完成！
echo ========================================
echo.
echo 接下来需要手动执行：
echo.
echo   cd D:\HuiXuanJiaSu\I_IAA_Work
echo   git add .gitlab-ci.yml
echo   git commit -m "回滚 CI 配置"
echo   git push
echo.
pause
