# Creating Plugins

Plugins bundle skills, agents, commands, hooks, and MCP servers for sharing across projects and teams.

## Plugin Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json      # Required manifest
├── commands/            # Slash commands (.md files)
├── agents/              # Agent definitions (.md files)
├── skills/              # Skills (folders with SKILL.md)
├── hooks/
│   └── hooks.json       # Event handlers
└── .mcp.json            # MCP server configs
```

**Important:** Only `plugin.json` goes inside `.claude-plugin/`. All other directories are at plugin root.

## Minimal Plugin

1. Create directory structure:
```bash
mkdir -p my-plugin/.claude-plugin
```

2. Create manifest at `my-plugin/.claude-plugin/plugin.json`:
```json
{
  "name": "my-plugin",
  "description": "Brief description of what this plugin does",
  "version": "1.0.0"
}
```

The `name` becomes the command namespace (e.g., `/my-plugin:command`).

## Converting Standalone to Plugin

```bash
# 1. Create plugin structure
mkdir -p my-plugin/.claude-plugin

# 2. Create manifest
cat > my-plugin/.claude-plugin/plugin.json << 'EOF'
{
  "name": "my-plugin",
  "description": "Migrated from standalone",
  "version": "1.0.0"
}
EOF

# 3. Copy existing files
cp -r .claude/commands my-plugin/
cp -r .claude/agents my-plugin/
cp -r .claude/skills my-plugin/

# 4. Migrate hooks (if any) to my-plugin/hooks/hooks.json
```

## Testing

```bash
claude --plugin-dir ./my-plugin
```

Test multiple plugins:
```bash
claude --plugin-dir ./plugin-one --plugin-dir ./plugin-two
```

## Distribution

Once tested, plugins can be shared via:
- Git repositories
- Plugin marketplaces
- Direct directory sharing

Users install with `/plugin install [source]`.
