# Tests

测试目录结构

## 目录说明

| 目录 | 说明 |
|------|------|
| `unit/` | 单元测试 |
| `integration/` | 集成测试 |
| `e2e/` | 端到端测试 |
| `fixtures/` | 测试数据 |

## 快速开始

```bash
# 运行所有测试
pytest

# 运行单元测试
pytest tests/unit/

# 运行集成测试
pytest tests/integration/
```

## 测试规范

1. 测试文件命名：`test_*.py`
2. 测试函数命名：`test_*`
3. 使用 pytest 框架
4. 保持测试独立性

## 示例

```python
# tests/unit/test_example.py
def test_example():
    assert 1 + 1 == 2
```
