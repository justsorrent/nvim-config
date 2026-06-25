# Java DAP + Aerial Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add IntelliJ-like debugging (nvim-dap stack) and symbol outline (aerial.nvim) to an existing NvChad + nvim-java config.

**Architecture:** Three new plugin files (aerial, dap, dap-ui/virtual-text) with keybindings defined inside each spec via `keys = {}` — matching the existing gradle.lua pattern. No manual Java adapter config: nvim-java manages java-debug automatically. All plugins lazy-load on `ft = java` or their respective keybindings.

**Tech Stack:** nvim-java (already present), mfussenegger/nvim-dap, rcarriga/nvim-dap-ui, nvim-neotest/nvim-nio, theHamsta/nvim-dap-virtual-text, stevearc/aerial.nvim

---

### Task 1: aerial.nvim plugin

**Files:**
- Create: `lua/plugins/aerial.lua`

- [ ] **Step 1: Create the plugin file**

```lua
-- lua/plugins/aerial.lua
return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>a", "<cmd>AerialToggle<cr>", desc = "Toggle aerial sidebar" },
    { "<leader>A", "<cmd>AerialToggle float<cr>", desc = "Toggle aerial float" },
  },
  opts = {
    backends = { "lsp", "treesitter" },
    layout = {
      default_direction = "right",
      placement = "edge",
    },
    attach_mode = "global",
    show_guides = true,
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Struct",
    },
  },
}
```

- [ ] **Step 2: Verify plugin loads**

Open nvim, run `:Lazy sync` to install aerial.nvim. Then open any Java file and press `<leader>a`.

Expected: aerial sidebar opens on the right showing class/method hierarchy. Cursor movement in the sidebar jumps to the corresponding symbol in the buffer.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/aerial.lua
git commit -m "feat: add aerial.nvim symbol outline"
```

---

### Task 2: nvim-dap plugin (core + UI + virtual text)

**Files:**
- Create: `lua/plugins/dap.lua`

- [ ] **Step 1: Create the plugin file**

```lua
-- lua/plugins/dap.lua
return {
  -- Core DAP client
  {
    "mfussenegger/nvim-dap",
    ft = { "java" },
    keys = {
      { "<F5>",      function() require("dap").continue() end,          desc = "DAP Continue" },
      { "<F10>",     function() require("dap").step_over() end,         desc = "DAP Step Over" },
      { "<F11>",     function() require("dap").step_into() end,         desc = "DAP Step Into" },
      { "<S-F11>",   function() require("dap").step_out() end,          desc = "DAP Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<leader>dB", function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end, desc = "DAP Conditional Breakpoint" },
      { "<leader>dr", function() require("dap").repl.open() end,        desc = "DAP REPL" },
    },
  },

  -- DAP UI (variables, stack, breakpoints, console panels)
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    ft = { "java" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI Toggle" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.40 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks",      size = 0.20 },
              { id = "watches",     size = 0.20 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 12,
          },
        },
      })

      -- Auto open/close UI with debug session (IntelliJ behaviour)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Inline variable values while stepping
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "java" },
    opts = {
      virt_text_pos = "eol",
      highlight_changed_variables = true,
    },
  },
}
```

- [ ] **Step 2: Sync and verify plugins install**

```
:Lazy sync
```

Expected: nvim-dap, nvim-dap-ui, nvim-dap-virtual-text, nvim-neotest/nvim-nio all appear in Lazy as installed.

- [ ] **Step 3: Verify DAP UI toggle**

Open any Java file. Press `<leader>du`.

Expected: DAP UI panels open (left panel with scopes/breakpoints/stacks/watches, bottom panel with repl/console). Press `<leader>du` again — panels close.

- [ ] **Step 4: Verify breakpoint toggle**

In a Java file, press `<leader>db` on any line.

Expected: breakpoint sign appears in the sign column (red dot or `B`).

- [ ] **Step 5: Commit**

```bash
git add lua/plugins/dap.lua
git commit -m "feat: add nvim-dap debugging stack for Java"
```

---

### Task 3: End-to-end debug session smoke test

This task has no file changes — it's a verification gate. Run it against a Gradle Java project.

- [ ] **Step 1: Open a Java file with a `main` method or a known entrypoint**

- [ ] **Step 2: Set a breakpoint**

Press `<leader>db` on a line inside the method body.

Expected: breakpoint sign appears.

- [ ] **Step 3: Start debug session via nvim-java**

Run `:JavaRunnerRunMain` or `:JavaDapConfig` (nvim-java commands) to launch a debug configuration, then `<F5>` to start.

Expected:
- DAP UI panels open automatically
- Execution halts at breakpoint
- Scopes panel shows local variables
- Virtual text shows variable values inline at end of lines

- [ ] **Step 4: Step through**

- `<F10>` — step over one line
- `<F11>` — step into a method call
- `<S-F11>` — step out of current frame

Expected: cursor follows execution, virtual text updates with new variable values.

- [ ] **Step 5: Continue and end session**

`<F5>` to continue. Session ends, DAP UI closes automatically.

- [ ] **Step 6: Conditional breakpoint**

Press `<leader>dB`, enter a condition like `i > 5`. Verify breakpoint only triggers when condition is true.
