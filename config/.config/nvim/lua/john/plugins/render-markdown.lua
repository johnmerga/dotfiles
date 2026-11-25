-- Renders markdown inside the buffer: headings, code blocks, tables,
-- checkboxes, links and callouts are drawn in place of the raw syntax.
--
-- The line under the cursor shows its raw text in normal mode, and the whole
-- buffer switches to raw text in insert mode, so editing stays predictable.
--
-- Uses the markdown / markdown_inline Treesitter parsers (already installed
-- by nvim-treesitter.lua) and nvim-web-devicons for code block icons.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  keys = {
    { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown rendering" },
  },
  opts = {
    -- LaTeX math needs an extra parser and a converter binary; keep it off
    -- so :checkhealth stays quiet.
    latex = { enabled = false },
    code = {
      -- pad code blocks to a common width instead of the full window
      width = "block",
      right_pad = 2,
    },
    completions = { lsp = { enabled = true } },
  },
}
