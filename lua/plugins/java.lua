-- Resolve a JDK home instead of hardcoding one, so this config works on any
-- machine (work laptop pins 21 via jenv, this one has 25).
local function jdk_home()
  local override = vim.env.NVIM_JAVA_HOME
  if override and vim.fn.isdirectory(override) == 1 then
    return override
  end

  -- Highest jenv-managed JDK. Names look like "25", "25.0.1" or
  -- "corretto64-21.0.10", so read the trailing version, never the vendor's
  -- bitness suffix.
  local best, best_major
  for _, dir in ipairs(vim.fn.glob(vim.fn.expand("~") .. "/.jenv/versions/*", false, true)) do
    local major = tonumber((vim.fn.fnamemodify(dir, ":t"):match("([%d._]+)$") or ""):match("^(%d+)") or "")
    if major and vim.fn.isdirectory(dir .. "/bin") == 1 and (not best_major or major > best_major) then
      best, best_major = dir, major
    end
  end
  if best then
    return best
  end

  if vim.fn.executable("/usr/libexec/java_home") == 1 then
    local out = vim.fn.system({ "/usr/libexec/java_home" })
    if vim.v.shell_error == 0 then
      return vim.trim(out)
    end
  end

  return vim.env.JAVA_HOME
end

-- jdtls wants an execution environment name ("JavaSE-25"), which the JDK's
-- own release file reports exactly.
local function java_se_name(home)
  local ok, lines = pcall(vim.fn.readfile, home .. "/release")
  if ok then
    for _, line in ipairs(lines) do
      local version = line:match('^JAVA_VERSION="(%d+)')
      if version then
        return "JavaSE-" .. version
      end
    end
  end
  local major = (vim.fn.fnamemodify(home, ":t"):match("([%d._]+)$") or ""):match("^(%d+)")
  return major and ("JavaSE-" .. major) or nil
end

return {
  "nvim-java/nvim-java",
  ft = { "java" },
  config = function()
    local home = jdk_home()
    if not home then
      vim.notify("nvim-java: no JDK found (set $NVIM_JAVA_HOME)", vim.log.levels.WARN)
      return
    end

    vim.env.JAVA_HOME = home

    require("java").setup({
      jdk = {
        auto_install = false,
      },
      spring_boot_tools = {
        enable = true,
      },
    })

    vim.lsp.config("jdtls", {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = java_se_name(home),
                path = home,
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
                home = home,
              },
            },
          },
        },
      },
    })
    vim.lsp.enable("jdtls")
  end,
}
