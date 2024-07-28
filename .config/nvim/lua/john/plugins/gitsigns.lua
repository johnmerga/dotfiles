return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      -- signs = {
      --   add = {
      --     hl = "GitSignsAdd",
      --     text = "+",
      --     numhl = "GitSignsAddNr",
      --     linehl = "GitSignsAddLn",
      --   },
      --   change = {
      --     hl = "GitSignsChange",
      --     text = "│",
      --     numhl = "GitSignsChangeNr",
      --     linehl = "GitSignsChangeLn",
      --   },
      --   delete = {
      --     hl = "GitSignsDelete",
      --     text = "_",
      --     numhl = "GitSignsDeleteNr",
      --     linehl = "GitSignsDeleteLn",
      --   },
      --   topdelete = {
      --     hl = "GitSignsDelete",
      --     text = "‾",
      --     numhl = "GitSignsDeleteNr",
      --     linehl = "GitSignsDeleteLn",
      --   },
      --   changedelete = {
      --     hl = "GitSignsChange",
      --     text = "~",
      --     numhl = "GitSignsChangeNr",
      --     linehl = "GitSignsChangeLn",
      --   },
      -- },
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`-> this makes the line number on the left side of the sign column to be highlighted
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`-> this makes the whole line(code snippet) to be highlighted
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' -> end of line, 'overlay' -> over the text
        delay = 1000,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>", -- Format the blame line

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local keymap = vim.keymap

        keymap.set("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
        keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
        keymap.set("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
        keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
        keymap.set("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
        -- add with description
        keymap.set("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
        keymap.set("n", "<leader>hD", function()
          gs.diffthis("~")
        end, { desc = "Diff this (cached)" })

        -- Text object
        keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,

      -- keymaps = {
      --   -- Default keymap options
      --   noremap = true,
      --   buffer = true,
      --
      --   ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
      --   ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },
      --
      --   ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      --   ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
      --   ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      --   ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
      --   ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
      --   ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
      --
      --   -- Text objects
      --   ["o ih"] = ':<C-U>lua require"gitsigns.actions',
      -- },
    })
  end,
}
