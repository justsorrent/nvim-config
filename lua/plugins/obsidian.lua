return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      { name = "Terra Mirabilis", path = "~/Documents/Obsidian/Terra Mirabilis" },
      { name = "IcewindDale", path = "~/Documents/Obsidian/IcewindDale" },
      { name = "Sessione Laurea Yda", path = "~/Documents/Obsidian/Sessione Laurea Yda" },
      { name = "loop-yda", path = "~/Documents/Obsidian/loop-yda" },
    },
    -- completion.blink / completion.nvim_cmp are deprecated: obsidian.nvim now
    -- serves completion through its built-in obsidian-ls LSP server.
    -- LazyVim's picker is snacks, not telescope
    picker = { name = "snacks.picker" },
    -- render-markdown.nvim handles in-buffer rendering
    ui = { enable = false },
  },
}
