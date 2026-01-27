@echo off
chcp 65001 >nul
echo ========================================
echo Ollama 模型下载
echo ========================================
echo.

echo 检测到你的配置：RTX 4090 24GB
echo.
echo 推荐模型：Qwen 2.5 32B
echo - 中文理解能力强
echo - 代码生成质量高
echo - 适合 DCC 软件控制
echo - 模型大小：约 19GB
echo.

set /p choice="是否下载 Qwen 2.5 32B？(Y/N): "
if /i "%choice%"=="Y" (
    echo.
    echo 开始下载 Qwen 2.5 32B...
    echo 预计需要 10-30 分钟（取决于网速）
    echo.
    C:\Users\dangd\AppData\Local\Programs\Ollama\ollama.exe pull qwen2.5:32b
    echo.
    echo ========================================
    echo 下载完成！
    echo ========================================
    echo.
    echo 下一步：运行 "启动测试.bat" 测试连接
    echo.
) else (
    echo.
    echo 取消下载。
    echo.
    echo 其他可选模型：
    echo   1. Qwen 2.5 14B (更快): ollama pull qwen2.5:14b
    echo   2. Qwen 2.5 7B (最快):  ollama pull qwen2.5:7b
    echo   3. Llama 3.1 70B:       ollama pull llama3.1:70b
    echo.
)

pause
