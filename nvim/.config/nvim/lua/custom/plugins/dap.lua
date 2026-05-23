return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- install codelldb via Mason (works for C, C++, and Rust)
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb" },
        automatic_installation = true,
        handlers = {},
      })

      -- codelldb adapter for C/C++ (rustaceanvim picks it up automatically for Rust)
      local codelldb_path = require("mason-registry").get_package("codelldb"):get_install_path()
        .. "/extension/adapter/codelldb"

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch (codelldb)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/build/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- UI auto-opens/closes with debug sessions
      dapui.setup()
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- inline variable values while stepping
      require("nvim-dap-virtual-text").setup({ commented = true })

      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "DAP: " .. desc })
      end
      map("<F5>",        dap.continue,          "Continue")
      map("<F10>",       dap.step_over,         "Step over")
      map("<F11>",       dap.step_into,         "Step into")
      map("<F12>",       dap.step_out,          "Step out")
      map("<leader>db",  dap.toggle_breakpoint, "[D]ebug [B]reakpoint")
      map("<leader>dB",  function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,                                      "[D]ebug conditional [B]reakpoint")
      map("<leader>du",  dapui.toggle,          "[D]ebug [U]I")
      map("<leader>dr",  dap.repl.open,         "[D]ebug [R]EPL")
      map("<leader>dl",  dap.run_last,          "[D]ebug run [L]ast")
    end,
  },
}
