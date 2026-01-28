# Bug Report: AI Creates Files in Wrong Root in Multi-Root Workspace

## Summary

In a multi-root workspace, when AI creates files (via fsWrite, strReplace, etc.), the files are saved to the wrong root folder, causing project pollution and confusion.

---

## Bug Description

**Environment:**
- Kiro Version: 0.8.140
- Platform: Windows x64
- Workspace: Multi-root (3 folders: K_Kiro_Work + Kiro-KB-Plugin + DevBrain-App)

**What Happened:**
1. Opened a multi-root workspace with projects A, B, C
2. Chat history shows Project A's context (first root)
3. Asked AI to create a document about Kiro IDE feature request
4. AI created the file in Project B (Kiro-KB-Plugin) instead of Project A (K_Kiro_Work)

**Expected Behavior:**
- File should be created in Project A (the active/first root)
- Or AI should ask which root to save to
- Or follow a clear, documented rule

**Actual Behavior:**
- File was created in Project B (seemingly random)
- No indication of which root would be used
- User had to manually move the file to correct location

---

## Reproduction Steps

1. Create a multi-root workspace:
   ```
   File → Add Folder to Workspace
   Add Project A, Project B, Project C
   ```

2. Start a chat conversation (chat history shows Project A's context)

3. Ask AI to create a file:
   ```
   User: "Create a feature request document"
   ```

4. Observe: File is created in Project B instead of Project A

---

## Impact

### Severity: High

**Why this is critical:**
- **Project pollution**: Files end up in wrong projects
- **Confusion**: User doesn't know where files will be created
- **Manual cleanup**: User must move files to correct location
- **Makes multi-root unusable**: Can't trust AI to save files correctly

### Real-World Scenario

```
Workspace: Frontend + Backend + Shared-Utils

User working on Frontend:
- Chat context: Frontend project
- Ask AI: "Create a new component"
- AI saves to Backend project ❌
- Component is in wrong place
- Build breaks
```

---

## Root Cause Analysis

**Possible causes:**
1. AI doesn't know which root is "active"
2. No clear rule for file creation in multi-root
3. AI might be using first alphabetically sorted root
4. AI might be using last added root

**What's missing:**
- No "active root" indicator in UI
- No way for user to specify target root
- No clear documentation on multi-root file creation behavior

---

## Expected Behavior

### Option 1: Use First Root (Simple)
- Always create files in the first root folder
- Clear, predictable behavior
- Document this in official docs

### Option 2: Use Active File's Root (Smart)
- Detect which root the currently active file belongs to
- Create new files in the same root
- Falls back to first root if no file is open

### Option 3: Ask User (Explicit)
- When creating files in multi-root, show a picker:
  ```
  Where should I create this file?
  ○ Project A (K_Kiro_Work)
  ○ Project B (Kiro-KB-Plugin)
  ○ Project C (DevBrain-App)
  ```

### Option 4: Root Selector in Chat (Best UX)
- Add a root selector in chat panel:
  ```
  ┌─────────────────────────────┐
  │ 💬 Kiro Chat                │
  │ 📁 Active Root: [A ▼]       │  ← User can change
  │                             │
  │ User: Create a file         │
  │ Kiro: Creating in Root A... │
  └─────────────────────────────┘
  ```

---

## Comparison with Other IDEs

### VS Code
- Extensions can specify target workspace folder
- User is prompted if ambiguous
- Clear API: `vscode.workspace.workspaceFolders[0]`

### Cursor
- Each project has separate context
- Files are created in current project
- No cross-project pollution

### Kiro (Current)
- ❌ No clear rule for file creation
- ❌ Files end up in wrong roots
- ❌ No user control over target root

---

## Related Issues

This bug is related to (but separate from):
- **Feature Request**: Multi-Root Workspace Chat History Isolation
  - That issue is about viewing chat history
  - This issue is about file creation behavior

**Both issues stem from the same root cause:**
- Lack of "active root" concept in multi-root workspaces
- No way to indicate which root the user is currently working in

---

## Workaround (Current)

**Manual file moving:**
1. AI creates file in wrong root
2. User notices the mistake
3. User manually moves file to correct root
4. User stages the deletion in wrong root's git
5. User stages the addition in correct root's git

**This is tedious and error-prone.**

---

## Proposed Fix

### Short-term (Quick Fix)
- Always use first root for file creation
- Document this behavior clearly
- At least make it predictable

### Long-term (Proper Solution)
- Implement "active root" concept
- Add root selector in chat UI
- Make file creation root-aware
- Consistent with chat history isolation

---

## Test Cases

### Test 1: File Creation in First Root
```
Given: Multi-root workspace (A, B, C)
When: User asks AI to create a file
Then: File should be created in Root A
```

### Test 2: File Creation with Active File
```
Given: Multi-root workspace (A, B, C)
And: User has a file open in Root B
When: User asks AI to create a related file
Then: File should be created in Root B
```

### Test 3: User Specifies Root
```
Given: Multi-root workspace (A, B, C)
When: User says "Create a file in Project B"
Then: File should be created in Root B
```

---

## Additional Context

**From user experience:**
- Discovered this bug while working on a feature request document
- Chat context was clearly in Project A (K_Kiro_Work)
- AI created file in Project B (Kiro-KB-Plugin)
- Had to manually move the file
- This makes multi-root workspaces unreliable for serious work

**User quote:**
> "I can't use multi-root workspace because I don't know where AI will save files. It causes project pollution."

---

## Priority

**Critical** because:
1. Breaks basic file creation functionality
2. Causes project pollution
3. Makes multi-root workspaces unusable
4. No workaround except avoiding multi-root
5. Affects every AI file operation (fsWrite, strReplace, etc.)

---

## Conclusion

Multi-root workspaces in Kiro need a clear "active root" concept. Without it:
- Chat history is confusing (separate issue)
- File creation is unpredictable (this issue)
- Users can't trust the AI to work in the right project

**Request:** Please implement a clear, documented rule for file creation in multi-root workspaces, ideally with user control over the target root.

---

**Submitted by:** [Your Name/GitHub Username]  
**Date:** 2026-01-28  
**Kiro Version:** 0.8.140  
**Platform:** Windows x64  
**Commit:** e9761ecebe507c32c4eefdc1f4f0a85a2bb29529

**Related:**
- Feature Request: Multi-Root Workspace Chat History Isolation
- Issue #195: Support for multi-root workspaces (Closed)
