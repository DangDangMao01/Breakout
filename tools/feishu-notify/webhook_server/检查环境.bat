@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ========================================
echo   环境检查工具
echo ========================================
echo.

cd /d "%~dp0"

set ERROR_COUNT=0
set WARNING_COUNT=0

REM ============================================
REM 1. Python 检查
REM ============================================
echo [检查 1/7] Python 环境
echo ----------------------------------------

python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Python
    echo [建议] 请安装 Python 3.7 或更高版本
    echo [下载] https://www.python.org/downloads/
    set /a ERROR_COUNT+=1
) else (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo [成功] Python 版本: !PYTHON_VERSION!
)
echo.

REM ============================================
REM 2. pip 检查
REM ============================================
echo [检查 2/7] pip 包管理器
echo ----------------------------------------

pip --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 pip
    set /a ERROR_COUNT+=1
) else (
    for /f "tokens=2" %%i in ('pip --version') do set PIP_VERSION=%%i
    echo [成功] pip 版本: !PIP_VERSION!
)
echo.

REM ============================================
REM 3. Flask 检查
REM ============================================
echo [检查 3/7] Flask 框架
echo ----------------------------------------

python -c "import flask; print(flask.__version__)" >nul 2>&1
if errorlevel 1 (
    echo [警告] Flask 未安装
    echo [建议] 运行 "一键部署.bat" 自动安装
    set /a WARNING_COUNT+=1
) else (
    for /f %%i in ('python -c "import flask; print(flask.__version__)"') do set FLASK_VERSION=%%i
    echo [成功] Flask 版本: !FLASK_VERSION!
)
echo.

REM ============================================
REM 4. requests 检查
REM ============================================
echo [检查 4/7] requests 库
echo ----------------------------------------

python -c "import requests; print(requests.__version__)" >nul 2>&1
if errorlevel 1 (
    echo [警告] requests 未安装
    echo [建议] 运行 "一键部署.bat" 自动安装
    set /a WARNING_COUNT+=1
) else (
    for /f %%i in ('python -c "import requests; print(requests.__version__)"') do set REQUESTS_VERSION=%%i
    echo [成功] requests 版本: !REQUESTS_VERSION!
)
echo.

REM ============================================
REM 5. 配置文件检查
REM ============================================
echo [检查 5/7] 配置文件
echo ----------------------------------------

if not exist "webhook_server.py" (
    echo [错误] 未找到 webhook_server.py
    set /a ERROR_COUNT+=1
) else (
    echo [成功] webhook_server.py 存在
)

if not exist "..\config\owners.json" (
    echo [警告] 未找到 owners.json
    echo [建议] 请配置项目负责人
    set /a WARNING_COUNT+=1
) else (
    echo [成功] owners.json 存在
)
echo.

REM ============================================
REM 6. 网络检查
REM ============================================
echo [检查 6/7] 网络配置
echo ----------------------------------------

REM 获取本机 IP
set LOCAL_IP=
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set IP=%%a
    set IP=!IP: =!
    if not "!IP!"=="127.0.0.1" (
        if not defined LOCAL_IP (
            set LOCAL_IP=!IP!
        )
    )
)

if not defined LOCAL_IP (
    echo [警告] 无法获取本机 IP
    echo [建议] 请检查网络连接
    set /a WARNING_COUNT+=1
    set LOCAL_IP=localhost
) else (
    echo [成功] 本机 IP: !LOCAL_IP!
)

REM 检查 5000 端口是否被占用
netstat -ano | findstr ":5000" >nul 2>&1
if not errorlevel 1 (
    echo [警告] 端口 5000 已被占用
    echo [建议] 请关闭占用该端口的程序
    set /a WARNING_COUNT+=1
) else (
    echo [成功] 端口 5000 可用
)
echo.

REM ============================================
REM 7. 防火墙检查
REM ============================================
echo [检查 7/7] 防火墙规则
echo ----------------------------------------

netsh advfirewall firewall show rule name="Webhook Server" >nul 2>&1
if errorlevel 1 (
    echo [警告] 防火墙规则未配置
    echo [建议] 运行以下命令（需要管理员权限）:
    echo.
    echo   New-NetFirewallRule -DisplayName "Webhook Server" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
    echo.
    set /a WARNING_COUNT+=1
) else (
    echo [成功] 防火墙规则已配置
)
echo.

REM ============================================
REM 检查结果汇总
REM ============================================
echo ========================================
echo   检查结果汇总
echo ========================================
echo.

if %ERROR_COUNT% EQU 0 (
    if %WARNING_COUNT% EQU 0 (
        echo [状态] ✅ 环境完美，可以部署！
        echo.
        echo [下一步]
        echo   1. 运行 "一键部署.bat" 完成部署
        echo   2. 或直接运行 "启动Webhook服务器.bat"
    ) else (
        echo [状态] ⚠️ 环境基本正常，有 %WARNING_COUNT% 个警告
        echo.
        echo [建议]
        echo   运行 "一键部署.bat" 自动修复警告
    )
) else (
    echo [状态] ❌ 环境不完整，有 %ERROR_COUNT% 个错误
    echo.
    echo [建议]
    echo   1. 根据上面的错误提示修复问题
    echo   2. 然后运行 "一键部署.bat"
)

echo.
echo ========================================
echo.

REM 生成检查报告
echo # 环境检查报告 > 环境检查报告.txt
echo. >> 环境检查报告.txt
echo 检查时间: %date% %time% >> 环境检查报告.txt
echo 错误数量: %ERROR_COUNT% >> 环境检查报告.txt
echo 警告数量: %WARNING_COUNT% >> 环境检查报告.txt
echo. >> 环境检查报告.txt
echo ## 系统信息 >> 环境检查报告.txt
echo. >> 环境检查报告.txt
if defined PYTHON_VERSION echo Python 版本: %PYTHON_VERSION% >> 环境检查报告.txt
if defined PIP_VERSION echo pip 版本: %PIP_VERSION% >> 环境检查报告.txt
if defined FLASK_VERSION echo Flask 版本: %FLASK_VERSION% >> 环境检查报告.txt
if defined REQUESTS_VERSION echo requests 版本: %REQUESTS_VERSION% >> 环境检查报告.txt
echo 本机 IP: %LOCAL_IP% >> 环境检查报告.txt
echo. >> 环境检查报告.txt

echo [保存] 检查报告已保存到: 环境检查报告.txt
echo.
pause
