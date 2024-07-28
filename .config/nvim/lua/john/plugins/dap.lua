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
  end,
}

return M
