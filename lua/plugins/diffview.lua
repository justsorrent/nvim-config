return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  opts = {
    view = {
      default = { layout = "diff2_vertical" },
      merge_tool = { layout = "diff3_horizontal" },
    },
    file_panel = {
      win_config = { position = "left", width = 35 },
    },
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diffview: open" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   desc = "Diffview: repo history" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>",         desc = "Diffview: close" },
  },
}
