return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require("conform")

    conform.setup({
      -- formatters = {
      --   eslint_d = {
      --     command = "eslint_d",
      --     args = { "--fix-to-stdout", "--stdin", "--config" },
      --   },
      -- },
      formatters_by_ft = {
        javascript = { "prettier", "eslint_d" },
        typescript = { "prettier", "eslint_d" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        -- python = { "isort", "black" },
      },
      -- filetypes listed here are only formatted on demand (<leader>mp),
      -- never on save
      format_on_save = function(bufnr)
        local manual_only = { php = true }
        if manual_only[vim.bo[bufnr].filetype] then
          return nil
        end
        return {
          lsp_format = "fallback",
          async = false,
          timeout_ms = 1000,
        }
      end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
