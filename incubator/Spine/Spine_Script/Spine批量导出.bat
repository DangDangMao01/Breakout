@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================
:: Spine 批量导出脚本
:: ============================================

:: ---------- 配置区域 ----------
:: Spine 安装路径（请根据实际情况修改）
set "SPINE_PATH=C:\Program Files\Spine\Spine.exe"

:: 输入文件夹（包含 .spine 文件的目录）
set "INPUT_FOLDER="

:: 输出文件夹
set "OUTPUT_FOLDER="

:: 导出格式: json 或 binary
set "EXPORT_FORMAT=json"

:: 是否打包图集: true 或 false
set "PACK_ATLAS=true"

:: 是否清理输出目录: true 或 false
set "CLEAN_OUTPUT=false"

:: ---------- 脚本开始 ----------

echo.
echo ========================================
echo        Spine 批量导出工具
echo ========================================
echo.

:: 检查 Spine 是否存在
if not exist "%SPINE_PATH%" (
    echo [错误] 找不到 Spine: %SPINE_PATH%
    echo 请修改脚本中的 SPINE_PATH 变量
    pause
    exit /b 1
)

:: 如果未设置输入文件夹，提示用户输入
if "%INPUT_FOLDER%"=="" (
    echo 请输入 Spine 项目文件夹路径:
    set /p "INPUT_FOLDER="
)

:: 如果未设置输出文件夹，使用输入文件夹下的 Export 子目录
if "%OUTPUT_FOLDER%"=="" (
    set "OUTPUT_FOLDER=%INPUT_FOLDER%\Export"
)

:: 检查输入文件夹是否存在
if not exist "%INPUT_FOLDER%" (
    echo [错误] 输入文件夹不存在: %INPUT_FOLDER%
    pause
    exit /b 1
)

:: 创建输出文件夹
if not exist "%OUTPUT_FOLDER%" (
    mkdir "%OUTPUT_FOLDER%"
    echo [信息] 已创建输出文件夹: %OUTPUT_FOLDER%
)

:: 构建导出参数
set "EXPORT_ARGS=--export %EXPORT_FORMAT%"

if "%PACK_ATLAS%"=="true" (
    set "EXPORT_ARGS=%EXPORT_ARGS% --pack"
)

if "%CLEAN_OUTPUT%"=="true" (
    set "EXPORT_ARGS=%EXPORT_ARGS% --clean"
)

echo.
echo [配置信息]
echo   输入文件夹: %INPUT_FOLDER%
echo   输出文件夹: %OUTPUT_FOLDER%
echo   导出格式: %EXPORT_FORMAT%
echo   打包图集: %PACK_ATLAS%
echo   清理输出: %CLEAN_OUTPUT%
echo.

:: 统计文件数量
set "COUNT=0"
set "SUCCESS=0"
set "FAILED=0"

for %%f in ("%INPUT_FOLDER%\*.spine") do (
    set /a COUNT+=1
)

if %COUNT%==0 (
    echo [警告] 未找到任何 .spine 文件
    pause
    exit /b 0
)

echo [开始] 共找到 %COUNT% 个 Spine 文件
echo.

:: 批量导出
for %%f in ("%INPUT_FOLDER%\*.spine") do (
    echo 正在导出: %%~nxf
    
    "%SPINE_PATH%" --input "%%f" --output "%OUTPUT_FOLDER%" %EXPORT_ARGS%
    
    if !errorlevel!==0 (
        echo   [成功] %%~nxf
        set /a SUCCESS+=1
    ) else (
        echo   [失败] %%~nxf
        set /a FAILED+=1
    )
    echo.
)

:: 显示结果
echo ========================================
echo [完成] 导出结果统计
echo   总计: %COUNT% 个文件
echo   成功: %SUCCESS% 个
echo   失败: %FAILED% 个
echo   输出位置: %OUTPUT_FOLDER%
echo ========================================

pause
