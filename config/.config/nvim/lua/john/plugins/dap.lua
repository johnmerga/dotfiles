local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui" },
    { "theHamsta/nvim-dap-virtual-text" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "jbyuki/one-small-step-for-vimkind" },
    { "leoluz/nvim-dap-go" },
    { "mfussenegger/nvim-dap-python" },
    { "nvim-neotest/nvim-nio" },
  },
  -- package for Go and Python
  -- stylua: ignore
  keys = {
    -- VS Code-style function keys
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
    { "<S-F5>", function() require("dap").terminate() end, desc = "Debug: Stop" },
    { "<F17>", function() require("dap").terminate() end, desc = "Debug: Stop" }, -- S-F5 in many terminals
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
    { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
    { "<F23>", function() require("dap").step_out() end, desc = "Debug: Step Out" }, -- S-F11 in many terminals
    { "<leader><leader>R", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
    { "<leader><leader>E", function() require("dapui").eval(vim.fn.input "[Expression] > ") end, desc = "Evaluate Input", },
    { "<leader><leader>C", function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
    { "<leader><leader>U", function() require("dapui").toggle() end, desc = "Toggle UI", },
    { "<leader><leader>b", function() require("dap").step_back() end, desc = "Step Back", },
    { "<leader><leader>c", function() require("dap").continue() end, desc = "Continue", },
    { "<leader><leader>d", function() require("dap").disconnect() end, desc = "Disconnect", },
    { "<leader><leader>e", function() require("dapui").eval() end, mode = {"n", "v"}, desc = "Evaluate", },
    { "<leader><leader>g", function() require("dap").session() end, desc = "Get Session", },
    { "<leader><leader>h", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", },
    { "<leader><leader>S", function() require("dap.ui.widgets").scopes() end, desc = "Scopes", },
    { "<leader><leader>i", function() require("dap").step_into() end, desc = "Step Into", },
    { "<leader><leader>o", function() require("dap").step_over() end, desc = "Step Over", },
    { "<leader><leader>p", function() require("dap").pause.toggle() end, desc = "Pause", },
    { "<leader><leader>q", function() require("dap").close() end, desc = "Quit", },
    { "<leader><leader>r", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
    { "<leader><leader>s", function() require("dap").continue() end, desc = "Start", },
    { "<leader><leader>t", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
    { "<leader><leader>x", function() require("dap").terminate() end, desc = "Terminate", },
    { "<leader><leader>u", function() require("dap").step_out() end, desc = "Step Out", },
  },
  opts = {
    setup = {
      osv = function(_, _)
        require("dap-go").setup()
      end,
      python = function(_, _)
        local dap_python = require("dap-python")
        dap_python.setup("python")

        -- Configure Django
        table.insert(require("dap").configurations.python, {
          type = "python",
          request = "launch",
          name = "Django",
          program = "${workspaceFolder}/manage.py",
          args = { "runserver" },
          django = true,
        })
      end,
    },
  },
  config = function(plugin, opts)
    require("nvim-dap-virtual-text").setup({
      commented = true,
    })

    local dap, dapui = require("dap"), require("dapui")
    dapui.setup({})

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Set up debuggers
    for k, _ in pairs(opts.setup) do
      opts.setup[k](plugin, opts)
    end

    -- Python-specific settings
    dap.adapters.python = {
      type = "executable",
      command = "python",
      args = { "-m", "debugpy.adapter" },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          return "python"
        end,
      },
    }

    -- Breakpoint signs that are visible (default is a plain "B")
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
    vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn", linehl = "Visual" })

    ---------------------------------------------------------------------------
    -- VS Code compatibility
    --
    -- nvim-dap reads ./.vscode/launch.json (relative to nvim's cwd) on every
    -- <F5>, so a project's existing VS Code debug configs show up as-is.
    ---------------------------------------------------------------------------
    -- VS Code tolerates trailing commas in launch.json; vim.json does not.
    require("dap.ext.vscode").json_decode = function(str, opts)
      return vim.json.decode(str:gsub(",(%s*[%]}])", "%1"), opts)
    end

    -- ${workspaceRoot} is VS Code's old name for ${workspaceFolder}; nvim-dap
    -- only knows the new one, so translate it (also inside table keys such as
    -- pathMappings).
    local function expand_workspace_root(v)
      if type(v) == "string" then
        return (v:gsub("%${workspaceRoot}", function()
          return vim.fn.getcwd()
        end))
      elseif type(v) == "table" then
        local out = {}
        for k, val in pairs(v) do
          out[expand_workspace_root(k)] = expand_workspace_root(val)
        end
        return setmetatable(out, getmetatable(v))
      end
      return v
    end
    dap.listeners.on_config["john.workspaceRoot"] = expand_workspace_root

    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

    ---------------------------------------------------------------------------
    -- PHP (Xdebug) -- adapter: mason "php-debug-adapter"
    ---------------------------------------------------------------------------
    dap.adapters.php = {
      type = "executable",
      command = mason_bin .. "php-debug-adapter",
    }

    -- Fallback when the project has no .vscode/launch.json. Xdebug runs in
    -- Docker and connects back to this port on the host; /application (path
    -- inside the container) is mapped to nvim's cwd, so open nvim in the
    -- folder that is mounted at /application (e.g. .../volumes/n1-api).
    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug (port 9093, /application -> cwd)",
        port = 9093,
        hostname = "0.0.0.0",
        pathMappings = { ["/application"] = "${workspaceFolder}" },
      },
    }

    ---------------------------------------------------------------------------
    -- JavaScript / TypeScript -- adapter: mason "js-debug-adapter"
    ---------------------------------------------------------------------------
    for _, t in ipairs({ "pwa-node", "pwa-chrome" }) do
      dap.adapters[t] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = { command = mason_bin .. "js-debug-adapter", args = { "${port}" } },
      }
    end
    -- launch.json files written for VS Code use "node"/"chrome"
    for vscode_type, pwa_type in pairs({ node = "pwa-node", chrome = "pwa-chrome" }) do
      dap.adapters[vscode_type] = function(cb, config)
        config.type = pwa_type
        cb(dap.adapters[pwa_type])
      end
    end

    local js_configs = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch current file (node)",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to node process (pick)",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to node --inspect (port 9229)",
        port = 9229,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
      },
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch Chrome (http://localhost:3000)",
        url = function()
          local url = vim.fn.input("URL: ", "http://localhost:3000")
          return url ~= "" and url or dap.ABORT
        end,
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
      },
    }
    for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" }) do
      dap.configurations[ft] = js_configs
    end
  end,
}

return M
