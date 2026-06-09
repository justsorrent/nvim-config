return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    use_local_fs = false,
    enable_builtin = true,
    default_remote = { "upstream", "origin" },
    picker = "telescope",
    picker_config = {
      use_emojis = true,
    },
    reaction_viewer_hint_icon = "",
    user_icon = " ",
    timeline_marker = "",
    timeline_indent = 2,
    right_bubble_delimiter = "",
    left_bubble_delimiter = "",
    github_hostname = "",
    snippet_context_lines = 4,
    gh_env = {},
    timeout = 5000,
    ui = {
      use_signcolumn = true,
    },
    issues = {
      order_by = {
        field = "CREATED_AT",
        direction = "DESC",
      },
    },
    pull_requests = {
      order_by = {
        field = "CREATED_AT",
        direction = "DESC",
      },
      always_select_remote_on_create = false,
    },
    file_panel = {
      size = 10,
      icons = true,
    },
  },
  keys = {
    { "<leader>op", "<cmd>Octo pr list<cr>",       desc = "Octo: PR list" },
    { "<leader>oc", "<cmd>Octo pr create<cr>",     desc = "Octo: create PR" },
    { "<leader>oi", "<cmd>Octo issue list<cr>",    desc = "Octo: issue list" },
    { "<leader>oI", "<cmd>Octo issue create<cr>",  desc = "Octo: create issue" },
    { "<leader>or", "<cmd>Octo review start<cr>",  desc = "Octo: start review" },
    { "<leader>os", "<cmd>Octo review submit<cr>", desc = "Octo: submit review" },
    { "<leader>oa", "<cmd>Octo actions<cr>",       desc = "Octo: actions" },
  },
}
