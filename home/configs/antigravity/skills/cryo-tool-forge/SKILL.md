---
name: cryo-tool-forge
description: Scaffolds, implements, tests, and registers new atomic FastMCP tools or capability packs in the Cryo codebase.
---

# Cryo Tool Forge

## Summary
An agentic development workflow for adding and refining atomic Unix, system, git, docker, and NixOS tools inside the Cryo MCP bridge repository (`~/Documents/Cryo`).

## When to Use
- User types `/forge-tool` or requests a new MCP tool or capability pack for Cryo.
- When expanding Antigravity's toolset with custom system or Nix primitives.

## Architecture Guidelines for Cryo Tools
1. **Packs & Tools Separation**:
   - Tools are organized by pack in `src/cryo/tools/<pack>.py` (e.g. `fs`, `git`, `system`, `docker`, `systemd`, `nixos`, `network`).
   - Pack constants and registrations reside in `src/cryo/tools/__init__.py`.
2. **Atomic Tool Design**:
   - Each tool function must be purely typed with Python 3.11+ type annotations (`path: str = "."`, `long: bool = True`).
   - Use clear, detailed docstrings. FastMCP uses docstrings for MCP tool description generation!
   - Return structured dictionaries (`{"status": "ok", ...}` or `{"status": "error", "error": "..."}`).
   - Include noise-filtering and truncation safeguards so tools never overwhelm LLM context windows (e.g. `IGNORED_DIRS`, `max_lines`, `max_depth`).
3. **Registration**:
   - Wrap the tool in a `ToolSpec`:
     ```python
     ToolSpec(
         name="tool_name",
         func=tool_function,
         description="Concise description...",
         pack=PACK,
     )
     ```
   - Register it in `src/cryo/tools/__init__.py`.
   - Update `instructions.md` with the new tool name and active tool count.
4. **Validation**:
   - Verify Python syntax and imports.
   - Run a quick test call via `python -m cryo.main` or stdio check to verify tool schema generation without error.
