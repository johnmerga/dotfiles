-- GitHub-style markdown preview in the browser, with live reload and
-- scroll sync. In-buffer rendering is handled by render-markdown.lua.
--
-- Needs Node: the preview server is installed with npm on first install.
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  ft = { "markdown" },
  build = "cd app && npm install",
  keys = {
    { "<leader>mb", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Toggle markdown preview in browser" },
  },
  init = function()
    -- keep the preview open when switching to another buffer
    vim.g.mkdp_auto_close = 0
  end,
}
