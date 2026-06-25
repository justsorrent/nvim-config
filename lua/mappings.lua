require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })
map("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- split management
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Copy current filepath into clipboard
map("n", "<leader>fp", function()
  local filePath = vim.fn.expand "%:~" -- Gets the file path relative to the home directory
  vim.fn.setreg("+", filePath) -- Copy the file path to the clipboard register
  print("File path copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" })

-- Session persistence
map("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Load session for the current directory" })
map("n", "<leader>qS", function()
  require("persistence").select()
end, { desc = "Select session to load" })
map("n", "<leader>ql", function()
  require("persistence").load { last = true }
end, { desc = "Load last session" })
map("n", "<leader>qd", function()
  require("persistence").stop()
end, { desc = "Stop persistence" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Route LSP references through Trouble instead of native quickfix
map("n", "grr", function()
  vim.lsp.buf.references(nil, {
    on_list = function(options)
      vim.fn.setqflist({}, " ", options)
      vim.cmd("Trouble qflist open focus=true")
    end,
  })
end, { desc = "LSP references (Trouble)" })

-- LSP code actions (explicit, NvChad default also maps this)
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })

-- Toggle format on save (conform.nvim)
map("n", "<leader>tf", function()
  vim.g.conform_format_on_save_disabled = not vim.g.conform_format_on_save_disabled
  if vim.g.conform_format_on_save_disabled then
    require("conform").setup({ format_on_save = false })
    vim.notify("Format on save disabled", vim.log.levels.WARN)
  else
    require("conform").setup({ format_on_save = { timeout_ms = 500, lsp_fallback = true } })
    vim.notify("Format on save enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle format on save" })

-- Gitsigns: diff vs PR base branch
map("n", "<leader>gP", function()
  local handle = io.popen("gh pr view --json baseRefName -q .baseRefName 2>/dev/null")
  if not handle then
    vim.notify("gh not found", vim.log.levels.ERROR)
    return
  end
  local base = handle:read("*l")
  handle:close()
  if not base or base == "" then
    vim.notify("No open PR found", vim.log.levels.WARN)
    return
  end
  local ref = "origin/" .. base
  vim.notify("Fetching " .. ref .. "…", vim.log.levels.INFO)
  vim.fn.jobstart({ "git", "fetch", "origin", base, "--no-tags", "--quiet" }, {
    on_exit = function(_, code)
      vim.schedule(function()
        if code ~= 0 then
          vim.notify("git fetch failed", vim.log.levels.ERROR)
          return
        end
        require("gitsigns").change_base(ref, true)
        require("gitsigns").refresh()
        vim.notify("Gitsigns base: " .. ref, vim.log.levels.INFO)
      end)
    end,
  })
end, { desc = "Gitsigns: diff vs PR base branch" })

map("n", "<leader>gR", function()
  require("gitsigns").reset_base(true)
  require("gitsigns").refresh()
  vim.notify("Gitsigns base: reset to HEAD", vim.log.levels.INFO)
end, { desc = "Gitsigns: reset base to HEAD" })

-- Spotless Apply via gradlew (searches upward from buffer dir)
map("n", "<leader>Gs", function()
  local buf_dir = vim.fn.expand "%:p:h"
  local gradlew = vim.fn.findfile("gradlew", buf_dir .. ";")
  if gradlew == "" then
    vim.notify("gradlew not found", vim.log.levels.ERROR)
    return
  end
  local gradlew_abs = vim.fn.fnamemodify(gradlew, ":p")
  local root = vim.fn.fnamemodify(gradlew_abs, ":h")
  vim.notify("Running spotlessApply…", vim.log.levels.INFO)
  vim.fn.jobstart({ gradlew_abs, "spotlessApply" }, {
    cwd = root,
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify("spotlessApply done", vim.log.levels.INFO)
          vim.cmd "checktime"
        else
          vim.notify("spotlessApply failed (exit " .. code .. ")", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, { desc = "Spotless Apply" })
