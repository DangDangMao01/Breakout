"""
安装脚本
"""

from setuptools import setup, find_packages

setup(
    name="dcc-agent",
    version="0.1.0",
    description="DCC 软件智能体统一控制系统",
    author="Your Name",
    packages=find_packages(),
    install_requires=[
        "langchain>=0.1.0",
        "langchain-community>=0.0.20",
        "ollama>=0.1.0",
        "chromadb>=0.4.0",
        "pydantic>=2.0.0",
        "python-dotenv>=1.0.0",
        "pyyaml>=6.0",
        "requests>=2.31.0",
        "pillow>=10.0.0",
    ],
    python_requires=">=3.8",
)
