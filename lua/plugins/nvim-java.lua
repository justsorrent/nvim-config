return {
  "nvim-java/nvim-java",
  config = function()
    local jdk21_home = "/Users/luca.sorrentino2/.jenv/versions/corretto64-21.0.10"
    vim.env.JAVA_HOME = jdk21_home

    require("java").setup {
      jdk = {
        auto_install = false,
      },
      spring_boot_tools = {
        enable = true,
      },
    }

    vim.lsp.config("jdtls", {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = jdk21_home,
                default = true,
              },
            },
          },
          import = {
            gradle = {
              enabled = true,
              wrapper = {
                enabled = true,
              },
              java = {
                home = jdk21_home,
              },
            },
          },
        },
      },
    })
    vim.lsp.enable("jdtls")
  end,
  ft = { "java" },
}
