@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ========================================
echo   GitLab Webhook 配置向导
echo ========================================
echo.
echo 本向导将帮助你配置项目负责人
echo.
pause

cd /d "%~dp0"

REM 检查 owners.json 是否存在
if not exist "..\config\owners.json" (
    echo [创建] 正在创建 owners.json...
    copy "..\config\owners_example.json" "..\config\owners.json" >nul
    echo [成功] 已创建配置文件
    echo.
)

echo ========================================
echo   当前配置
echo ========================================
echo.
type "..\config\owners.json"
echo.
echo ========================================
echo.

echo [提示] 配置格式说明:
echo.
echo 单人通知:
echo   "项目名": "email@huixuanjiasu.com"
echo.
echo 多人通知:
echo   "项目名": ["email1@huixuanjiasu.com", "email2@huixuanjiasu.com"]
echo.
echo 项目名匹配规则:
echo   - GitLab 项目路径: grouptwogame/Y_遇水发财
echo   - 配置 key: Y_遇水发财
echo   - 只要项目路径包含 key 即可匹配
echo.
echo ========================================
echo.

set /p EDIT_CONFIG="是否编辑配置文件？(Y/N): "
if /i "%EDIT_CONFIG%"=="Y" (
    echo.
    echo [打开] 正在打开配置文件...
    start notepad "..\config\owners.json"
    echo.
    echo [提示] 请在记事本中编辑配置
    echo [提示] 编辑完成后保存并关闭记事本
    echo.
    pause
)

echo.
echo ========================================
echo   配置验证
echo ========================================
echo.

REM 验证 JSON 格式
python -c "import json; json.load(open('../config/owners.json', 'r', encoding='utf-8'))" >nul 2>&1
if errorlevel 1 (
    echo [错误] JSON 格式不正确
    echo [建议] 请检查配置文件格式
    echo.
    pause
    exit /b 1
) else (
    echo [成功] JSON 格式正确
)

REM 显示配置的项目数量
for /f %%i in ('python -c "import json; data=json.load(open('../config/owners.json', 'r', encoding='utf-8')); print(len([k for k in data.keys() if not k.startswith('_')]))"') do set PROJECT_COUNT=%%i
echo [成功] 已配置 %PROJECT_COUNT% 个项目
echo.

echo ========================================
echo   配置完成
echo ========================================
echo.
echo [下一步]
echo   1. 运行 "一键部署.bat" 完成部署
echo   2. 或运行 "启动Webhook服务器.bat" 启动服务器
echo.
pause
