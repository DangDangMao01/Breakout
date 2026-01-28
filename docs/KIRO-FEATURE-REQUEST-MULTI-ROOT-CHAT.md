# Feature Request: Multi-Root Workspace Chat History Isolation

## Summary

When using multi-root workspaces in Kiro, the chat history only loads from the first root folder, ignoring chat histories from other roots. This makes multi-root workspaces impractical for projects that require separate chat contexts.

---

## Current Behavior

**Scenario 1: Single Root (Works as Expected ✅)**
```
Open Project A alone → See Project A's chat history ✅
Open Project B alone → See Project B's chat history ✅
```

**Scenario 2: Multi-Root (Broken ❌)**
```
1. Open Project A
2. Add Project B to workspace (File → Add Folder to Workspace)
3. Result: Only see Project A's chat history
4. Project B's chat history is completely ignored ❌
```

---

## Expected Behavior

Multi-root workspaces should handle chat history similar to how they handle Hooks:

**From your official blog post:**
> "Hooks are listed together, but each is tied to its root. So, a hook in shared-ui/.kiro/hooks/ will only trigger when files in shared-ui change."

**Chat history should work the same way:**
- Each root maintains its own chat history
- Switching between roots automatically switches chat context
- Or provide a UI selector to choose which root's chat to view

---

## Why This Matters

### 1. Context Pollution
When working on multiple projects simultaneously, mixing chat histories causes:
- Confusion about which project is being discussed
- AI responses based on wrong project context
- Loss of project-specific conversation history

### 2. Inconsistent Design
Kiro already implements root isolation for:
- ✅ **Steering files**: Each root's steering files are loaded conditionally
- ✅ **Agent Hooks**: Each hook is tied to its root
- ✅ **MCP configs**: Each root can have its own MCP configuration
- ❌ **Chat history**: Only first root is loaded (inconsistent!)

### 3. Real-World Use Cases
Multi-root workspaces are designed for scenarios like:
- Frontend + Backend + Shared Library
- Monorepo with multiple packages
- App + Plugin development

These scenarios require **separate chat contexts** for each root.

---

## Proposed Solutions

### Option 1: Automatic Context Switching (Recommended)

**Behavior:**
- Track which root the user is currently working in (based on active file)
- Automatically load that root's chat history
- Switch chat context when user switches to a different root

**Implementation:**
```typescript
// Pseudo-code
vscode.window.onDidChangeActiveTextEditor((editor) => {
  const activeRoot = getWorkspaceFolder(editor.document.uri);
  if (activeRoot !== currentChatRoot) {
    saveChatHistory(currentChatRoot);
    loadChatHistory(activeRoot);
    currentChatRoot = activeRoot;
  }
});
```

**Advantages:**
- Seamless user experience
- No manual intervention needed
- Consistent with Kiro's "intelligent assistant" philosophy

---

### Option 2: Manual Root Selector

**Behavior:**
- Add a dropdown in the chat panel to select which root's chat to view
- Similar to how you handle MCP config selection in multi-root

**UI Mockup:**
```
┌─────────────────────────────┐
│ 💬 Kiro Chat                │
│ 📁 Root: [Project A ▼]      │  ← Dropdown selector
│                             │
│ User: Continue development  │
│ Kiro: Sure, let me help...  │
└─────────────────────────────┘
```

**Advantages:**
- Explicit control for users
- Easier to implement
- Consistent with existing multi-root UI patterns

---

### Option 3: Unified Chat with Root Tags

**Behavior:**
- Merge all roots' chat histories
- Tag each message with its root
- Allow filtering by root

**Advantages:**
- See all conversations in one place
- Can search across all roots

**Disadvantages:**
- More complex UI
- Potential context confusion

---

## Technical Details

### Current Storage (Assumption)
```
Project A/.kiro/chat-history.json  ← Loaded when A is opened alone
Project B/.kiro/chat-history.json  ← Loaded when B is opened alone

Multi-root workspace:
- Only Project A's chat is loaded ❌
- Project B's chat is ignored
```

### Proposed Storage
```
Project A/.kiro/chat-history.json
Project B/.kiro/chat-history.json

Multi-root workspace:
- Load both chat histories
- Switch between them based on active root
- Or provide UI to select which one to view
```

---

## Comparison with Other IDEs

### GitHub Copilot
- Chat context is based on **current file**
- Automatically adjusts to project context
- No explicit multi-root support, but works naturally

### Cursor
- Each project has **independent chat history**
- Switching projects switches chat context
- Clean separation between projects

### Kiro (Current)
- ❌ Multi-root chat history not supported
- ❌ Only first root's chat is loaded
- ❌ Inconsistent with Hooks/Steering/MCP design

---

## Impact

### Without This Feature
- Multi-root workspaces are **impractical** for chat-heavy workflows
- Users forced to use single-root workspaces
- Defeats the purpose of multi-root support

### With This Feature
- Multi-root workspaces become **fully functional**
- Consistent user experience across all Kiro features
- Better alignment with real-world development workflows

---

## User Feedback

**From my experience:**
- I discovered this issue when trying to work on multiple related projects
- Initially thought it was a bug, but realized it's a missing feature
- Had to switch back to single-root workspaces to avoid chat confusion

**Expected from other users:**
- Anyone using multi-root for serious development will hit this issue
- May not report it because they assume "it's just how it works"
- But it significantly limits multi-root usability

---

## Priority

**High Priority** because:
1. Multi-root workspaces are a **promoted feature** (official blog post)
2. Chat is a **core feature** of Kiro
3. Current behavior is **inconsistent** with other multi-root features
4. Relatively **easy to implement** (similar to Hooks isolation)

---

## Related Issues

### Issue #195: Support for multi-root workspaces (Closed)
**Link:** https://github.com/kirodotdev/Kiro/issues/195  
**Status:** Closed (July 2025)  
**What it solved:** File access and Steering file creation for all roots in multi-root workspaces

**Key difference from this request:**
- Issue #195 focused on **file access** - ensuring all files from all roots are discoverable
- This request focuses on **chat history isolation** - ensuring each root's chat context is accessible

**Why this is a separate issue:**
- Issue #195 successfully implemented multi-root support for files, Steering, Hooks, and MCP
- However, **chat history switching was not included** in that implementation
- This is a natural extension of Issue #195's work, applying the same per-root isolation pattern to chat history

### Official Documentation
- Multi-root workspace announcement: https://kiro.dev/changelog/spec-correctness-and-cli/
- Multi-root workspaces guide: https://kiro.dev/docs/editor/multi-root-workspaces/

**Note:** The official documentation mentions multi-root support for Steering, Hooks, and MCP, but does not mention chat history behavior in multi-root scenarios.

---

## Conclusion

Multi-root workspace support in Kiro is well-designed for Steering, Hooks, and MCP. **Issue #195** successfully implemented file access for all roots. However, **chat history isolation is missing**, making multi-root workspaces impractical for chat-heavy workflows.

**This request is a natural extension of Issue #195's work**, applying the same per-root isolation pattern to chat history.

**Request:** Please implement chat history isolation for multi-root workspaces, similar to how Hooks are isolated per root.

**Suggested approach:** Option 1 (Automatic Context Switching) for the best user experience.

---

**Thank you for considering this feature request!**

If you need any clarification or would like to discuss implementation details, I'm happy to provide more information.

---

**Submitted by:** [Your Name/GitHub Username]  
**Date:** 2026-01-28  
**Kiro Version:** 0.8.140 (Latest as of 2026-01-28)  
**Platform:** Windows x64  
**Commit:** e9761ecebe507c32c4eefdc1f4f0a85a2bb29529
