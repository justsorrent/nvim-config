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
