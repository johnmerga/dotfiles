-- set leader key to space
vim.g.mapleader = " "

-- nmap <silent> gx :!open <cWORD><cr>
-- covnert the above command to lua

local keymap = vim.keymap -- for conciseness

----------Open URL under cursor in browser-------------------
local open_command = "xdg-open"
if vim.fn.has("mac") == 1 then
  open_command = "open"
end

local function url_repo()
  local cursorword = vim.fn.expand("<cfile>")
  if string.find(cursorword, "^[a-zA-Z0-9-_.]*/[a-zA-Z0-9-_.]*$") then
    cursorword = "https://github.com/" .. cursorword
  end
  return cursorword or ""
end

keymap.set("n", "gx", function()
  vim.fn.jobstart({ open_command, url_repo() }, { detach = true })
end, { silent = true })
--------------------- ^^Open URL under cursor in browser^^-------------------

-- General Keymaps -------------------
--
--debugging

----- Custom keymaps -----
--use  for LSP  Dynamic workspace symbols
keymap.set(
  "n",
  "<leader>wt",
  "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
  { desc = "LSP Dynamic workspace symbols" }
)
-- list symbols in current buffer
--lua require('telescope.builtin').lsp_document_symbols({ symbols='function' })
keymap.set("n", "<leader>wm", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "LSP Document symbols" })
-- use jk to exit insert mode
keymap.set("i", "kk", "<ESC>", { desc = "Exit insert mode with jk" })
-- remap <C-f> to <M-f> for normal mod for forwarding and backwarding pages
keymap.set("n", "<M-f>", "<C-f>", { desc = "next page" })
keymap.set("n", "<M-u>", "<C-b>", { desc = "next page" })
-- scroll up and down
keymap.set("n", "<M-e>", "<C-e>", { desc = "scroll down" })
keymap.set("n", "<M-y>", "<C-y>", { desc = "scroll up" })
-- go to (previous,next) tab
keymap.set("n", "<M-h>", "<cmd>tabprevious<CR>", { desc = "go to previous tab" })
keymap.set("n", "<M-l>", "<cmd>tabnext<CR>", { desc = "go to next tab" })
-- switching between splitted buffers
keymap.set("n", "<M-w>", "<C-w>w", { desc = "switch between splitted buffers" })
keymap.set("n", "<M-W>", "<C-w>W", { desc = "switch between splitted buffers vertically" })

-- move lines up and down
-- keymap.set("n", "<M-j>", ":m .+1<CR>==", { desc = "move line down" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})
-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
