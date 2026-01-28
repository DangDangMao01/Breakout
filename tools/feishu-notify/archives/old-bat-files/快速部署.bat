@echo off
chcp 65001 >nul
echo ============================================================
echo 美术资源通知系统 v3.0 - 快速部署脚本
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

REM 复制脚本
echo [1/3] 复制通知脚本...
copy /Y "%SOURCE_DIR%notify_v3_auto_match.py" "%TARGET_DIR%\notify.py"
if %errorlevel% neq 0 (
    echo ❌ 复制脚本失败
    pause
    exit /b 1
)
echo ✓ 脚本复制成功

REM 复制配置模板（如果不存在）
echo.
echo [2/3] 检查配置文件...
if exist "%TARGET_DIR%\owners.json" (
    echo ⚠️  owners.json 已存在，跳过复制
    echo 💡 如需更新，请手动编辑或删除后重新运行
) else (
    copy /Y "%SOURCE_DIR%owners_example.json" "%TARGET_DIR%\owners.json"
    if %errorlevel% neq 0 (
        echo ❌ 复制配置失败
        pause
        exit /b 1
    )
    echo ✓ 配置文件复制成功
)

REM 显示下一步操作
echo.
echo [3/3] 部署完成！
echo.
echo ============================================================
echo ✅ 文件已复制到公司工程
echo ============================================================
echo.
echo 📋 下一步操作:
echo.
echo 1. 编辑 owners.json 配置人员邮箱
echo    路径: %TARGET_DIR%\owners.json
echo.
echo 2. 更新 .gitlab-ci.yml 添加通知任务
echo    参考: v3.0部署指南.md
echo.
echo 3. 提交代码测试
echo    cd %TARGET_DIR%
echo    git add notify.py owners.json .gitlab-ci.yml
echo    git commit -m "部署美术通知系统 v3.0"
echo    git push
echo.
echo 📖 详细说明请查看: v3.0部署指南.md
echo.
pause
