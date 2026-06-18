return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- the rewrite; the legacy API (master) is frozen
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local ts = require("nvim-treesitter")

      -- main branch no longer takes a big config table; setup() is optional
      ts.setup()

      -- parsers to keep installed (install() is async on first run)
      ts.install({
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "python",
      })

      -- autotag moved to its own plugin setup (no longer a treesitter module)
      require("nvim-ts-autotag").setup()

      -- main branch: highlighting/indent are started per-buffer, not via a
      -- module table. Start treesitter for any filetype that has a parser.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("john_treesitter", { clear = true }),
        callback = function(args)
          -- pcall: silently skip filetypes without an installed parser
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
