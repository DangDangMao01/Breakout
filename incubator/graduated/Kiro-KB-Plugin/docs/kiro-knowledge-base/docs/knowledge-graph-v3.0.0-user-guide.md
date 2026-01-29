# Knowledge Graph User Guide (v3.0.0)

## Overview

The Knowledge Graph visualizes your knowledge base as an interactive network of connected nodes. Each node represents a knowledge file, and edges show relationships between them.

## Opening the Graph

### Command Palette

1. Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
2. Type "Kiro: Show Knowledge Graph"
3. Press Enter

### Choosing Knowledge Base

If you have both a local project knowledge base and a central knowledge base, you'll be prompted to choose:

- **📁 Local Project KB** - Knowledge specific to current project
- **☁️ Central KB** - Your personal cross-project knowledge

## Understanding the Graph

### Nodes (Circles)

**What they represent:**
- Each node = one knowledge file
- Color = domain/category
- Size = importance (number of connections)

**Node sizes:**
- Small (6px) = Few or no connections
- Medium (8-10px) = Some connections
- Large (12px) = Many connections (hub node)

### Edges (Lines)

**Strong connections** (thick, colored lines):
- Internal links: `[[other-file]]` references
- Direct relationships you've explicitly created

**Weak connections** (thin, gray lines):
- Shared domain + 2+ common tags
- Implicit relationships

### Colors

Each domain gets a unique color:
- 🟢 Green - e.g., "backend"
- 🔵 Blue - e.g., "frontend"
- 🟠 Orange - e.g., "devops"
- 🔴 Pink - e.g., "database"
- 🟣 Purple - e.g., "testing"
- 🔷 Cyan - e.g., "documentation"
- 🟡 Yellow - e.g., "architecture"
- 🟤 Brown - e.g., "other"

## Interacting with the Graph

### Hover Over Node

**Shows tooltip with:**
- 📄 File title
- 🏷️ Domain
- 🔗 Number of connections
- 🏷️ Tags (if any)

**Example:**
```
API Authentication Best Practices
Domain: backend
Connections: 7
Tags: security, api, jwt, oauth
```

### Click Node

**Opens the file** in VS Code editor
- File opens in new tab
- You can edit immediately
- Graph stays open

### Drag Node

**Repositions the node**
- Click and hold on node
- Drag to new position
- Release to drop
- Useful for organizing clusters

### Zoom

**Mouse wheel:**
- Scroll up = Zoom in
- Scroll down = Zoom out
- Range: 0.1x to 5x

### Pan (Move Canvas)

**Click and drag** on empty space:
- Click on background (not a node)
- Drag to move entire graph
- Useful for large graphs

### Reset View

**Click "Reset" button** in toolbar:
- Returns to default zoom (1x)
- Centers the graph
- Re-runs layout algorithm

### Toggle Legend

**Click "Legend" button** to show/hide:
- Domain color mappings
- Helps identify node categories

## Toolbar Information

### Knowledge Base Info

**Left side shows:**
- 📁 or ☁️ icon (local or central)
- Full path to knowledge base

### Statistics

**Middle section shows:**

📊 **Nodes: 42**
- Total number of knowledge files

🔗 **Links: 87**
- Total number of connections

🌟 **Core: 8**
- Hub nodes (5+ connections)
- Most important/referenced files

⚠️ **Isolated: 3**
- Files with no connections
- May need linking or tagging

## Reading the Graph

### Identifying Important Knowledge

**Look for:**
- Large nodes = Frequently referenced
- Many connections = Central concepts
- Strong edges = Explicit relationships

**Example:**
```
Large node "API Design Principles"
  ↓ (strong edge)
"REST Best Practices"
  ↓ (strong edge)
"GraphQL vs REST"
```

### Finding Related Knowledge

**Follow the edges:**
1. Find a node you're interested in
2. Look at connected nodes
3. Strong edges = directly related
4. Weak edges = similar topics

### Spotting Gaps

**Isolated nodes (⚠️):**
- No connections to other knowledge
- Consider adding links or tags
- May be outdated or incomplete

**Missing connections:**
- Related nodes not connected?
- Add `[[internal links]]` in files
- Add common tags

## Best Practices

### Creating Good Graphs

1. **Use internal links**
   ```markdown
   See also: [[related-topic]]
   ```

2. **Tag consistently**
   ```yaml
   ---
   domain: backend
   tags: [api, security, authentication]
   ---
   ```

3. **Set domains**
   ```yaml
   ---
   domain: frontend  # or backend, devops, etc.
   ---
   ```

4. **Link related concepts**
   - Reference other files
   - Build knowledge networks
   - Create learning paths

### Organizing Large Graphs

**For 50+ nodes:**

1. **Use domains** to color-code
2. **Drag nodes** into clusters
3. **Zoom in** on specific areas
4. **Reset view** to see overview

**For 100+ nodes:**

1. Consider splitting into multiple KBs
2. Use more specific domains
3. Focus on strong connections
4. Archive old/unused knowledge

## Troubleshooting

### Graph is Empty

**Possible causes:**
- No markdown files in knowledge base
- Files not in `solutions/`, `notes/`, or `discussions/` folders

**Solution:**
- Add knowledge files
- Check folder structure
- Refresh graph

### Nodes Not Connected

**Possible causes:**
- No internal links between files
- No shared tags (need 2+ common tags)
- Different domains

**Solution:**
- Add `[[internal links]]`
- Add common tags
- Review frontmatter

### Graph is Cluttered

**Solutions:**
- Zoom in on specific area
- Drag nodes to organize
- Use domains to color-code
- Consider archiving old knowledge

### Can't Find a File

**Solutions:**
- Use VS Code search (Cmd/Ctrl + Shift + F)
- Check file explorer
- Look for isolated nodes (⚠️)

### Graph is Slow

**For very large graphs (200+ nodes):**
- Close and reopen graph
- Restart VS Code
- Consider splitting knowledge base

## Tips & Tricks

### Quick Navigation

1. **Hover to preview** - See file info without opening
2. **Click to open** - Edit file immediately
3. **Keep graph open** - Navigate while editing

### Building Knowledge Networks

1. **Start with a hub** - Create central concept file
2. **Link related topics** - Use `[[links]]`
3. **Add tags** - Group similar concepts
4. **Review graph** - Find gaps and connections

### Learning Paths

1. **Follow strong edges** - Explicit learning sequence
2. **Explore weak edges** - Related topics
3. **Check core nodes** - Important concepts

### Maintenance

1. **Weekly review** - Check isolated nodes
2. **Add missing links** - Connect related knowledge
3. **Update tags** - Keep consistent
4. **Archive old** - Remove outdated knowledge

## Limitations (v3.0.0)

The current version is a **simplified implementation** focused on core visualization. The following features from v2.53.0 are not available:

- ❌ Search bar for filtering nodes
- ❌ Dropdown filters (folder, tag, domain)
- ❌ Right-click context menu
- ❌ Detail panel with file preview
- ❌ "Ask Kiro" integration
- ❌ "Create Related Knowledge" action
- ❌ Web search integration

These features may return in future versions (v3.1.0+). See the [migration guide](./knowledge-graph-v3.0.0-migration.md) for details.

## Future Enhancements

Planned for v3.1.0 and beyond:

- 🔍 Search and filter functionality
- 📁 Category filtering
- 🏷️ Tag filtering
- 🎨 Multiple layout options
- 📸 Export graph as image
- ⌨️ Keyboard navigation

## Feedback

If you have suggestions or encounter issues:

1. Check this guide and the [migration guide](./knowledge-graph-v3.0.0-migration.md)
2. Review the [requirements spec](../.kiro/specs/knowledge-graph-v3.0.0-requirements.md)
3. Open an issue on GitHub
4. Share your feedback in discussions

---

**Version**: 3.0.0  
**Last Updated**: 2026-01-14  
**Related Docs**: [Migration Guide](./knowledge-graph-v3.0.0-migration.md) | [Requirements](../.kiro/specs/knowledge-graph-v3.0.0-requirements.md)
