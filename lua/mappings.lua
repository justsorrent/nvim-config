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
