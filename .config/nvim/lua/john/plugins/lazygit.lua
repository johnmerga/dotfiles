return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
    "LazyGitToggle",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  keys = {
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "open lazy git" },
  },
}
