@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ========================================
echo   GitLab Webhook 飞书通知
echo   一键部署完整包
echo ========================================
echo.
echo 本脚本将引导你完成完整的部署流程
echo.
pause

cd /d "%~dp0\webhook_server"

REM ============================================
REM 步骤 1: 环境检查
REM ============================================
echo.
echo ========================================
echo   步骤 1: 环境检查
echo ========================================
echo.

call 检查环境.bat

echo.
set /p CONTINUE="环境检查完成，是否继续？(Y/N): "
if /i not "%CONTINUE%"=="Y" (
    echo.
    echo [退出] 部署已取消
    pause
    exit /b 0
)

REM ============================================
REM 步骤 2: 配置项目负责人
REM ============================================
echo.
echo ========================================
echo   步骤 2: 配置项目负责人
echo ========================================
echo.

call 配置向导.bat

echo.
set /p CONTINUE="配置完成，是否继续？(Y/N): "
if /i not "%CONTINUE%"=="Y" (
    echo.
    echo [退出] 部署已取消
    pause
    exit /b 0
)

REM ============================================
REM 步骤 3: 一键部署
REM ============================================
echo.
echo ========================================
echo   步骤 3: 一键部署
echo ========================================
echo.

call 一键部署.bat

echo.
echo ========================================
echo   部署流程完成
echo ========================================
echo.
echo [下一步]
echo   1. 在 GitLab 中配置 Webhook（详见 部署信息.txt）
echo   2. 运行 "测试Webhook.bat" 测试功能
echo.
echo [文档]
echo   - 快速部署指南.md
echo   - README.md
echo.
pause
