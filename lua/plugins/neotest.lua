return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "rcasia/neotest-java", commit = "f08ee74" },
    },
    ft = { "java" },
    keys = {
      { "<leader>t", desc = "+test" },
      { "<leader>tc", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: run current class" },
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Test: run nearest" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: toggle summary" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Test: toggle output panel" },
      { "<leader>tO", function() require("neotest").output.open({ enter = true }) end, desc = "Test: open output" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Test: stop" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-java")({
            ignore_wrapper = false,
            jvm_args = {
              -- "-Dspring.profiles.active=ci",
              -- "-Xmx512m",
            },
          }),
        },
        output = {
          open_on_run = true,
        },
        output_panel = {
          enabled = true,
        },
        summary = {
          open = "botright vsplit | vertical resize 40",
        },
      })
    end,
  },
}
