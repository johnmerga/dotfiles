-- VS Code-style search & replace panel (ripgrep under the hood).
--
-- The panel is a normal buffer: results stay put while you jump between them,
-- until you close it yourself (\c or :close). Search input can span several
-- lines (multiline search).
--
-- Inside the panel (VS Code muscle memory):
--   <M-c>  toggle Match Case        <M-w>  toggle Match Whole Word
--   <M-r>  toggle Regex             <CR>   open result (panel stays open)
--   <Down>/<Up> open next/prev result in the other window
--   \r replace all   \q send to quickfix   \c close  (\ = localleader)
--   g?     show every grug-far keymap (replace all, sync line, history, ...)
--
-- Defaults mirror VS Code: case-insensitive, plain text (not regex).

-- flag -> present means the VS Code toggle is OFF (case/regex) or ON (word)
local toggles = {
  ["<M-c>"] = { flag = "--ignore-case", name = "Match Case", on_when_absent = true },
  ["<M-r>"] = { flag = "--fixed-strings", name = "Regex", on_when_absent = true },
  ["<M-w>"] = { flag = "--word-regexp", name = "Whole Word", on_when_absent = false },
}

local DEFAULT_FLAGS = "--ignore-case --fixed-strings"

local function toggle_flag(spec)
  local inst = require("grug-far").get_instance()
  if not inst then
    return
  end
  local now_present = inst:toggle_flags({ spec.flag })[1]
  local on = (now_present ~= spec.on_when_absent)
  vim.notify(spec.name .. ": " .. (on and "ON" or "OFF"), vim.log.levels.INFO, { title = "Search" })
end

local function open(opts)
  opts = opts or {}
  opts.prefills = vim.tbl_extend("keep", opts.prefills or {}, { flags = DEFAULT_FLAGS })
  require("grug-far").open(opts)
end

local function visual_selection()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  return table.concat(lines, "\n")
end

return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  -- stylua: ignore
  keys = {
    { "<leader>Sp", function() open() end, desc = "Search/replace in project" },
    { "<leader>Sf", function() open({ prefills = { paths = vim.fn.expand("%:p") } }) end, desc = "Search/replace in current file" },
    { "<leader>Sw", function() open({ prefills = { search = vim.fn.expand("<cword>"), flags = "--ignore-case --fixed-strings --word-regexp" } }) end, desc = "Search word under cursor in project" },
    { "<leader>Sw", function()
        local sel = visual_selection()
        vim.cmd("normal! \27") -- leave visual mode
        open({ prefills = { search = sel } })
      end, mode = "x", desc = "Search selection in project" },
    { "<leader>Sb", function()
        local sel = visual_selection()
        vim.cmd("normal! \27")
        open({ prefills = { search = sel, paths = vim.fn.expand("%:p") } })
      end, mode = "x", desc = "Search selection in current file" },
  },
  config = function()
    require("grug-far").setup({
      engine = "ripgrep",
      -- keep the panel in a vertical split on the left, like VS Code's sidebar
      windowCreationCommand = "topleft vsplit",
      transient = false, -- results buffer stays until you close it
      openTargetWindow = { preferredLocation = "right" },
      helpLine = { enabled = true },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "grug-far",
      group = vim.api.nvim_create_augroup("john_grug_far", { clear = true }),
      callback = function(ev)
        for lhs, spec in pairs(toggles) do
          vim.keymap.set({ "n", "i" }, lhs, function()
            toggle_flag(spec)
          end, { buffer = ev.buf, desc = "Toggle " .. spec.name })
        end

        -- ripgrep refuses newlines in a pattern unless --multiline is set, so
        -- add it while the search input spans several lines (like VS Code),
        -- and drop it again for single-line searches (it is slower).
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
          buffer = ev.buf,
          callback = function()
            local inst = require("grug-far").get_instance()
            if not inst then
              return
            end
            -- read the live buffer text; get_status_info() lags behind edits
            local get = function(name)
              return require("grug-far.inputs").getInputValue(inst._context, ev.buf, name)
            end
            local wants = get("search"):find("\n", 1, true) ~= nil
            local has = (" " .. get("flags") .. " "):find(" --multiline ", 1, true) ~= nil
            if wants ~= has then
              inst:toggle_flags({ "--multiline" })
            end
          end,
        })
      end,
    })
  end,
}
