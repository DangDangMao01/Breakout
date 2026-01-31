@echo off
echo ========================================
echo 配置 Breakout Git 远程仓库
echo ========================================
echo.

cd /d D:\G_GitHub\Breakout

echo [1/5] 删除旧的远程仓库配置...
git remote remove origin
echo.

echo [2/5] 添加新的远程仓库...
git remote add origin https://github.com/DangDangMao01/Breakout.git
echo.

echo [3/5] 查看远程仓库配置...
git remote -v
echo.

echo [4/5] 检查当前分支...
git branch
echo.

echo [5/5] 推送到 GitHub（尝试 master 和 main）...
echo 尝试推送 master 分支...
git push -u origin master
if %errorlevel% neq 0 (
    echo.
    echo master 分支推送失败，尝试 main 分支...
    git branch -M main
    git push -u origin main
)
echo.

echo ========================================
echo 完成！
echo ========================================
echo.
echo 如果还有问题，请把错误信息截图给我
pause
