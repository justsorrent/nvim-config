-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.relativenumber = false
vim.g.autoformat = false

-- LazyVim turns spell on for markdown/text/gitcommit. Check English and
-- Italian together, so a word is only flagged when neither knows it.
-- Dictionaries live in ~/.config/nvim/spell/; `zg` adds personal
-- words to ~/.local/share/nvim/site/spell/en.utf-8.add.
vim.opt.spelllang = { "en", "it" }
