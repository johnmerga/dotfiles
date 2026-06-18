# Neovim treesitter on the `main` branch

After upgrading to Neovim 0.12 and updating plugins, `nvim-treesitter` and
`nvim-treesitter-textobjects` landed on their rewritten **`main`** branch. The
config was rewritten to the `main` API (imperative `require('nvim-treesitter')
.install()` + a `FileType` autocmd calling `vim.treesitter.start()`, and
hand-written textobject keymaps via the `select`/`move`/`swap` modules) rather
than pinning back to the legacy `master` branch.

## Considered Options

- **Pin back to `master`** — rejected: keeps the old declarative `setup({...})`
  config (and `incremental_selection`) working with near-zero changes and needs
  no `tree-sitter` CLI, but `master` is frozen/maintenance-only. Staying on it
  defers the same migration to the next laptop and rots over time.
- **Migrate to `main`** — chosen: current and maintained, matches "fix it so it
  won't happen again." Cost: `incremental_selection` is gone (no built-in
  replacement), textobject keymaps must be written imperatively, and parser
  compilation now shells out to the `tree-sitter` CLI.

## Consequences

- **`tree-sitter-cli` is now a hard system dependency.** The `main` branch
  compiles parsers by invoking the `tree-sitter` binary; without it every
  non-bundled parser fails with `Error during "tree-sitter build": ... 'tree-sitter'`.
  It is declared in `setup-01-bootstrap` (alongside `neovim`, which was also
  previously undeclared). Neovim still ships built-in parsers for lua/vim/query/
  markdown/c, so those highlight even before the CLI is installed.
- `incremental_selection` (`<C-space>` grow / `<bs>` shrink) no longer exists.
- Highlighting/indent are started per-buffer by a `FileType` autocmd, guarded by
  `pcall(vim.treesitter.start)` so filetypes without a parser fail silently.
- `nvim-ts-autotag` is configured on its own (`require('nvim-ts-autotag').setup()`)
  since it is no longer a treesitter module.
- **Telescope must track its `master` branch, not `0.1.x`.** The `0.1.x`
  previewer calls `nvim-treesitter.parsers.ft_to_lang`, removed on `main`, which
  crashes the preview with `attempt to call field 'ft_to_lang' (a nil value)`.
  `master` uses native `vim.treesitter.language.get_lang` + `vim.treesitter.start`.
