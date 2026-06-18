return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- ---- keymaps: one LspAttach autocmd for every server ----
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("john_lsp_attach", { clear = true }),
      callback = function(ev)
        local keymap = vim.keymap
        local function opts(desc)
          return { buffer = ev.buf, noremap = true, silent = true, desc = desc }
        end

        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts("Show LSP references"))
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts("Show LSP definitions"))
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts("Show LSP implementations"))
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts("Show LSP type definitions"))
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("See available code actions"))
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Smart rename"))
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts("Show buffer diagnostics"))
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts("Show line diagnostics"))
        keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, opts("Go to previous diagnostic"))
        keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, opts("Go to next diagnostic"))
        keymap.set("n", "K", vim.lsp.buf.hover, opts("Show documentation for what is under cursor"))
        keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts("Restart LSP"))
      end,
    })

    -- ---- diagnostic signs (replaces deprecated vim.fn.sign_define) ----
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    -- ---- default config applied to every server ----
    vim.lsp.config("*", {
      capabilities = cmp_nvim_lsp.default_capabilities(),
    })

    -- ---- per-server overrides ----
    vim.lsp.config("svelte", {
      on_attach = function(client)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            -- notify svelte LSP about changes to JS/TS files
            client:notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    vim.lsp.config("graphql", {
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.config("pyright", {
      settings = {
        pyright = {
          disableOrganizeImports = true, -- using Ruff
          diagnostics = {
            enable = true,
            enableSemantic = true,
            enableTypeChecking = true,
          },
        },
        python = {
          analysis = {
            ignore = { "*" }, -- using Ruff
          },
        },
      },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          -- make the language server recognize the "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- Servers are installed and auto-enabled by mason-lspconfig (v2).
    -- Plain servers (html, gopls, ts_ls, intelephense, cssls, tailwindcss,
    -- prismals, ruff) need no extra config here beyond the "*" defaults.
  end,
}
