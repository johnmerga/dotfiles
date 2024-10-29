return {

  "github/copilot.vim",
  lazy = false,
  config = function()
    vim.g.copilot_filetypes = {
      yaml = true,
      markdown = true,
    }
    -- Mapping tab is already used by NvChad
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
    vim.g.copilot_no_tab_map = true
    -- The mapping is set to other key, see custom/lua/mappings
    -- or run <leader>ch to see copilot mapping section
  end,

  --    "zbirenbaum/copilot.lua",
  --    cmd = "Copilot",
  --    event = "InsertEnter",
  --    config = function()
  -- require("copilot").setup({})
  --    end,
}
