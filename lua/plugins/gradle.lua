return {
  "oclay1st/gradle.nvim",
  cmd = { "Gradle", "GradleExec", "GradleInit", "GradleFavorites" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    gradle_executable = vim.fn.getcwd() .. '/gradlew',
  },
  keys = {
    { "<leader>G",  desc = "+Gradle",                                              mode = { "n", "v" } },
    { "<leader>Gg", "<cmd>Gradle<cr>",         desc = "Gradle Projects (F = toggle favorite)" },
    { "<leader>Gf", "<cmd>GradleFavorites<cr>", desc = "Gradle Favorites (run saved tasks)" },
    { "<leader>Ge", "<cmd>GradleExec<cr>",      desc = "Gradle Exec (run arbitrary task)" },
  },
}
