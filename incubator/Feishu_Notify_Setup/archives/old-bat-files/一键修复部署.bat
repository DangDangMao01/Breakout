@echo off
chcp 65001 >nul
echo ========================================
echo   飞书通知系统 - 一键修复部署
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

echo [步骤 1/5] 备份当前配置...
if exist "D:\HuiXuanJiaSu\I_IAA_Work\.gitlab-ci.yml" (
    copy /Y "D:\HuiXuanJiaSu\I_IAA_Work\.gitlab-ci.yml" "D:\HuiXuanJiaSu\I_IAA_Work\.gitlab-ci.yml.backup.%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%" >nul
    echo [成功] 已备份到 .gitlab-ci.yml.backup.%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
) else (
    echo [警告] 未找到原配置文件
)
echo.

echo [步骤 2/5] 部署修复后的 .gitlab-ci.yml...
copy /Y ".gitlab-ci.yml" "D:\HuiXuanJiaSu\I_IAA_Work\.gitlab-ci.yml" >nul
if %errorLevel% equ 0 (
    echo [成功] .gitlab-ci.yml 已部署
) else (
    echo [错误] 部署失败
    pause
    exit /b 1
)
echo.

echo [步骤 3/5] 检查 C:\GitLab-Runner 目录...
if exist "C:\GitLab-Runner\notify.py" (
    echo [成功] notify.py 存在
) else (
    echo [警告] notify.py 不存在，正在复制...
    copy /Y "scripts\notify_v3_auto_match.py" "C:\GitLab-Runner\notify.py" >nul
    echo [成功] notify.py 已复制
)

if exist "C:\GitLab-Runner\owners.json" (
    echo [成功] owners.json 存在
) else (
    echo [警告] owners.json 不存在，正在复制...
    copy /Y "config\owners.json" "C:\GitLab-Runner\owners.json" >nul
    echo [成功] owners.json 已复制
)
echo.

echo [步骤 4/5] 显示配置摘要...
echo ----------------------------------------
echo 项目路径: GroupTwoGame/groupTowArt_Hb
echo 负责人: wangxinlai@huixuanjiasu.com
echo CI 配置: D:\HuiXuanJiaSu\I_IAA_Work\.gitlab-ci.yml
echo 脚本位置: C:\GitLab-Runner\notify.py
echo 配置位置: C:\GitLab-Runner\owners.json
echo ----------------------------------------
echo.

echo [步骤 5/5] 准备提交...
echo.
echo 接下来需要手动执行：
echo.
echo   cd D:\HuiXuanJiaSu\I_IAA_Work
echo   git add .gitlab-ci.yml
echo   git commit -m "修复 CI 配置格式错误"
echo   git push
echo.
echo 然后查看 GitLab CI 日志确认通知发送成功
echo.

echo ========================================
echo   部署完成！
echo ========================================
echo.
echo 提示：
echo 1. 现在可以提交你的美术资源了
echo 2. 提交后立即查看 GitLab CI 日志
echo 3. 确认飞书收到通知
echo 4. 如有问题，运行"回滚配置.bat"
echo.
pause
