# Java DAP + Aerial Design

**Date:** 2026-05-20
**Scope:** Add IntelliJ-like debugging and symbol outline to existing Java nvim setup

## Context

Existing: NvChad + nvim-java (jdtls) + gradle.nvim + conform. Java LSP already working.
Gap: no debugger, no symbol outline.

## Components

### Debugging (nvim-dap stack)

- **nvim-dap** — core debug adapter protocol client
- **nvim-dap-ui** — IDE-style panels (variables, call stack, breakpoints, console)
- **nvim-dap-virtual-text** — inline variable values while stepping (IntelliJ-style hints)
- **nvim-java** already manages the Java debug adapter (java-debug) — no manual adapter config needed

DAP UI auto-opens on session start, auto-closes on exit.

Layout mirrors IntelliJ debug tool window:
- Left: scopes/variables
- Bottom: console/REPL
- Right: call stack + breakpoints

### Symbol Outline (aerial.nvim)

- Persistent sidebar on right
- Backed by LSP (jdtls) — shows classes, methods, fields
- Cursor syncs bidirectionally
- Mirrors IntelliJ Structure panel

## Files

| File | Change |
|------|--------|
| `lua/plugins/dap.lua` | New — nvim-dap, nvim-dap-ui, nvim-dap-virtual-text specs |
| `lua/plugins/aerial.lua` | New — aerial.nvim spec |
| `lua/mappings.lua` | Add DAP + aerial keybindings |

## Keybindings

| Key | Action |
|-----|--------|
| `<F5>` | Continue / Start debug session |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<S-F11>` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>du` | Toggle DAP UI panels |
| `<leader>dr` | Open DAP REPL |
| `<leader>a` | Toggle aerial sidebar |
| `<leader>A` | Open aerial in float (quick nav) |

## Constraints

- nvim-java handles adapter install — do not manually configure dap for java
- Must lazy-load DAP on ft=java or explicit open to avoid startup overhead
- Aerial loads on first toggle, not at startup
