# 归档文件说明

> 本文件夹存放已废弃或测试用的文件

---

## 📁 目录说明

### ci-configs/
存放旧版本的 GitLab CI 配置文件

**已归档的配置**：
- `.gitlab-ci-correct.yml`
- `.gitlab-ci-final-fix.yml`
- `.gitlab-ci-final-simple.yml`
- `.gitlab-ci-final.yml`
- `.gitlab-ci-fixed.yml`
- `.gitlab-ci-prod.yml`
- `.gitlab-ci-simple.yml`
- `.gitlab-ci-test.yml`
- `.gitlab-ci-v3.1.yml`
- `.gitlab-ci-working.yml`

**当前使用**: 根目录的 `.gitlab-ci.yml`

---

### old-scripts/
存放旧版本的通知脚本

**已归档的脚本**：
- `notify.py` - v1.0 基础版本
- `notify_v2_enhanced.py` - v2.0 增强版本

**当前使用**: `scripts/notify_v3_auto_match.py` (v3.1)

---

### test-files/
存放测试文件

**文件列表**：
- `test_feishu_api.py` - 飞书 API 测试
- `test_feishu_connection.py` - 飞书连接测试
- `commit-message.txt` - 测试提交信息

---

## ⚠️ 注意事项

1. 这些文件仅供参考，不建议直接使用
2. 如需回滚到旧版本，请参考对应的部署指南
3. 定期清理不需要的归档文件

---

**归档时间**: 2026-01-22  
**整理人**: Kiro AI Assistant
