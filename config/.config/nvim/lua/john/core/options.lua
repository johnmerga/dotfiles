local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
-- opt.clipboard:append("unnamedplus") -- use system clipboard as default register
vim.o.clipboard = "unnamedplus"

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- folding (the fold method itself is set per buffer in nvim-treesitter.lua)
opt.foldlevel = 99 -- open files with every fold expanded
opt.foldlevelstart = 99
opt.foldtext = "" -- a closed fold shows its first line with normal highlighting
opt.fillchars:append({ fold = " " }) -- no trailing dots after a closed fold

-- Fold arrow next to the line number, like the VS Code gutter:
--   angle-down  = an open fold starts on this line
--   angle-right = closed fold
-- The built-in 'foldcolumn' is not used because it prints nesting-level
-- digits when it is one cell wide.
function _G.john_fold_icon()
  if vim.bo.buftype ~= "" then
    return "" -- file tree, search panel, terminals, ...
  end
  local lnum = vim.v.lnum
  local icon = " "
  if vim.v.virtnum == 0 then
    if vim.fn.foldclosed(lnum) == lnum then
      icon = "\u{f105}" -- nf-fa-angle_right
    elseif vim.fn.foldlevel(lnum) > 0 then
      -- Treesitter marks the first line of a fold with ">level"
      local ok, expr = pcall(vim.treesitter.foldexpr, lnum)
      local starts = ok and type(expr) == "string" and expr:sub(1, 1) == ">"
      if starts or vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
        icon = "\u{f107}" -- nf-fa-angle_down
      end
    end
  end
  return " %#FoldColumn#" .. icon .. "%* "
end
opt.statuscolumn = "%s%=%l%{%v:lua.john_fold_icon()%}"

-- turn off swapfile
opt.swapfile = false

-- spellcheck
opt.spelllang = "en_us"
opt.spell = true -- enable spellcheck
