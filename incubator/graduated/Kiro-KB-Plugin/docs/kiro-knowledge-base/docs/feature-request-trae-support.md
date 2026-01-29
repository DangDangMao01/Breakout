# 功能需求：Trae IDE 对话整理支持

> 状态：**待开发** | 优先级：**中** | 日期：2026-01-09

---

## 📋 需求背景

当前"对话整理"功能仅支持 Kiro IDE 的对话格式，用户希望在 Trae IDE 中也能使用此功能。

---

## 🔍 技术调研

### Trae 对话存储

| 项目 | 值 |
|------|-----|
| 存储位置 | `%APPDATA%\Trae\ModularData\ai-agent\database.db` |
| 存储格式 | SQLite 数据库 |
| 数据库大小 | ~23 MB |
| 相关文件 | `database.db`, `database.db-shm`, `database.db-wal` |

### Kiro 对话存储（对比）

| 项目 | 值 |
|------|-----|
| 存储位置 | `%APPDATA%\Kiro\User\globalStorage\kiro.kiroagent\workspace-sessions\` |
| 存储格式 | JSON 文件（.json / .chat） |
| 解析方式 | 直接读取 JSON |

---

## 🛠️ 实现方案

### 方案 A：添加 SQLite 支持（推荐）

**依赖**：
- `better-sqlite3` 或 `sql.js`（纯 JS，无需编译）

**实现步骤**：
1. 添加 SQLite 依赖到 `package.json`
2. 创建 `traeDigest.ts` 模块
3. 解析 Trae 数据库表结构
4. 提取对话内容
5. 转换为统一的 `ChatSession` 格式
6. 复用现有的 `analyzeConversation()` 函数

**代码结构**：
```typescript
// traeDigest.ts
import Database from 'better-sqlite3';

const TRAE_DB_PATH = path.join(
    process.env.APPDATA || '',
    'Trae', 'ModularData', 'ai-agent', 'database.db'
);

export function getTraeSessions(): ChatSession[] {
    const db = new Database(TRAE_DB_PATH, { readonly: true });
    // 查询对话表
    // 转换为 ChatSession 格式
    db.close();
    return sessions;
}
```

**优点**：
- 完整支持 Trae 对话
- 可扩展支持其他 SQLite 存储的 IDE

**缺点**：
- 增加依赖（~2MB）
- 需要了解 Trae 数据库结构

### 方案 B：使用 sql.js（纯 JS）

**依赖**：
- `sql.js`（WebAssembly 实现，无需编译）

**优点**：
- 跨平台兼容性好
- 无需 native 编译

**缺点**：
- 性能略低
- 包体积较大（~1MB wasm）

---

## 📝 待确认事项

1. **Trae 数据库表结构**
   - [ ] 对话表名称
   - [ ] 消息字段（role, content, timestamp）
   - [ ] 会话 ID 字段
   - [ ] 工作区关联字段

2. **兼容性测试**
   - [ ] Trae 版本兼容性
   - [ ] 数据库锁定问题（Trae 运行时能否读取）
   - [ ] 数据库版本迁移

---

## 🎯 验收标准

1. ✅ 在 Trae IDE 中安装插件后，"对话整理"功能可用
2. ✅ 能正确识别和解析 Trae 对话历史
3. ✅ 对话内容能正确转换为知识文档
4. ✅ 不影响 Kiro IDE 的现有功能
5. ✅ 自动检测当前 IDE 类型，使用对应的解析器

---

## 📅 计划版本

**目标版本**：v2.53.0 或更高

**前置任务**：
- [ ] 安装 sqlite3 工具，分析 Trae 数据库结构
- [ ] 确认数据库表结构和字段
- [ ] 评估依赖大小和兼容性

---

## 📎 相关文件

- `kiro-knowledge-base/extension/src/conversationDigest.ts` - 现有对话整理模块
- `kiro-knowledge-base/NEXT-STEPS.md` - 开发计划

---

## 💡 扩展思考

### 支持更多 IDE

| IDE | 对话存储格式 | 支持难度 |
|-----|-------------|---------|
| Kiro | JSON 文件 | ✅ 已支持 |
| Trae | SQLite | ⏳ 待开发 |
| Cursor | 待调研 | 未知 |
| VSCode + Copilot | 待调研 | 未知 |
| Windsurf | 待调研 | 未知 |

### 统一对话格式

考虑定义一个统一的对话格式接口：

```typescript
interface UnifiedChatSession {
    id: string;
    source: 'kiro' | 'trae' | 'cursor' | 'copilot';
    messages: Array<{
        role: 'user' | 'assistant';
        content: string;
        timestamp?: number;
    }>;
    metadata: {
        workspacePath?: string;
        projectName?: string;
        createdAt: number;
        updatedAt: number;
    };
}
```

---

*创建日期：2026-01-09*  
*最后更新：2026-01-09*
