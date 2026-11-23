return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")

    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install (and auto-enable via vim.lsp.enable)
      ensure_installed = {
        "vtsls", -- TS/JS: same engine as VS Code (replaces ts_ls)
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "ruff", -- was ruff_lsp
        "gopls",
        "intelephense", -- php (was configured but never auto-installed before)
      },
      -- installed servers are enabled with vim.lsp.enable() automatically;
      -- ts_ls is excluded so it can't run next to vtsls on machines where
      -- it is still installed from before.
      automatic_enable = { exclude = { "ts_ls" } },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint", -- python linter
        "eslint_d", -- js linter
        "php-debug-adapter", -- xdebug (vscode-php-debug)
        "js-debug-adapter", -- node/chrome (vscode-js-debug)
      },
    })
  end,
}
