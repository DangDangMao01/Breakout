@echo off
chcp 65001 >nul
echo ============================================================
echo 美术资源通知系统 v3.0 - 部署到公司工程
echo ============================================================
echo.

REM 设置路径
set "SOURCE_DIR=%~dp0"
set "TARGET_DIR=D:\HuiXuanJiaSu\I_IAA_Work"

echo 📁 源目录: %SOURCE_DIR%
echo 📁 目标目录: %TARGET_DIR%
echo.

REM 检查目标目录是否存在
if not exist "%TARGET_DIR%" (
    echo ❌ 错误: 目标目录不存在
    echo 请检查路径: %TARGET_DIR%
    pause
    exit /b 1
)

echo 🚀 开始部署...
echo.

REM 1. 复制脚本
echo [1/2] 复制通知脚本...
copy /Y "%SOURCE_DIR%notify_v3_auto_match.py" "%TARGET_DIR%\notify.py"
if %errorlevel% neq 0 (
    echo ❌ 复制脚本失败
    pause
    exit /b 1
)
echo ✓ 脚本复制成功: notify.py

REM 2. 创建测试配置
echo.
echo [2/2] 创建测试配置...
(
echo {
echo     "_comment": "项目资源通知配置 - 测试版",
echo     "_说明": "项目名称 → 负责人邮箱",
echo.    
echo     "测试文件": "wangxinlai@huixuanjiasu.com",
echo     "Y_遇水发财": "zhaolida@huixuanjiasu.com",
echo     "遇水发财": "zhaolida@huixuanjiasu.com"
echo }
) > "%TARGET_DIR%\owners.json"

if %errorlevel% neq 0 (
    echo ❌ 创建配置失败
    pause
    exit /b 1
)
echo ✓ 配置文件创建成功: owners.json

REM 显示完成信息
echo.
echo ============================================================
echo ✅ 部署完成！
echo ============================================================
echo.
echo 📋 已部署的文件:
echo    ✓ notify.py
echo    ✓ owners.json
echo.
echo 📝 配置内容:
echo    测试文件 → wangxinlai@huixuanjiasu.com
echo    Y_遇水发财 → zhaolida@huixuanjiasu.com
echo.
echo 🧪 下一步测试:
echo    1. 提交代码到 Git
echo       cd %TARGET_DIR%
echo       git add notify.py owners.json
echo       git commit -m "测试：更新通知系统"
echo       git push
echo.
echo    2. 查看 GitLab CI 日志
echo       确认通知是否发送成功
echo.
echo    3. 检查飞书是否收到通知
echo.
pause
