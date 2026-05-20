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
