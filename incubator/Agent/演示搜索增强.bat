@echo off
chcp 65001 >nul
echo ========================================
echo 搜索增强功能演示
echo ========================================
echo.

cd /d "%~dp0"

echo [步骤 1] 安装搜索依赖...
echo.
pip install duckduckgo-search requests --quiet
echo.

echo [步骤 2] 测试基本搜索...
echo.
python -c "from duckduckgo_search import DDGS; results = list(DDGS().text('Blender 4.0', max_results=3)); print('搜索成功！找到', len(results), '个结果'); [print(f'{i+1}. {r[\"title\"]}') for i, r in enumerate(results)]"
echo.

echo [步骤 3] 测试 Ollama 集成...
echo.
echo 现在可以运行完整示例：
echo python examples/web_search_example.py
echo.

pause
