return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- install codelldb via Mason (works for C, C++, and Rust)
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb", "delve", "js" },
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

      -- Odin emits DWARF, so codelldb debugs it like C
      dap.configurations.odin = {
        {
          name = "Build package (-debug) & launch",
          type = "codelldb",
          request = "launch",
          program = function()
            local cwd = vim.fn.getcwd()
            local out = cwd .. "/build/" .. vim.fs.basename(cwd) .. "-debug"
            vim.fn.mkdir(cwd .. "/build", "p")
            local res = vim.system({ "odin", "build", ".", "-debug", "-out:" .. out }, { cwd = cwd }):wait()
            if res.code ~= 0 then
              vim.notify("odin build failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
              return require("dap").ABORT
            end
            return out
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Launch executable",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- delve adapter + go configs (debug file/test/attach); also used by neotest-golang
      require("dap-go").setup()

      -- js-debug (vscode-js-debug) for Node / TypeScript / React in the browser
      for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = vim.fn.exepath("js-debug-adapter"),
            args = { "${port}" },
          },
        }
      end
      -- .vscode/launch.json uses "node"/"chrome"; js-debug only understands the pwa-* names
      for _, alias in ipairs({ "node", "chrome" }) do
        dap.adapters[alias] = function(cb, config)
          local pwa = "pwa-" .. alias
          config.type = pwa
          local adapter = vim.deepcopy(dap.adapters[pwa])
          cb(adapter)
        end
      end

      local js_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
      for _, ft in ipairs(js_filetypes) do
        dap.configurations[ft] = {
          {
            -- node >= 23 strips TS types natively, so .ts files run directly
            name = "Launch current file (node)",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          {
            name = "Attach to node process (--inspect)",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          {
            name = "Debug in Chrome (dev server)",
            type = "pwa-chrome",
            request = "launch",
            url = function()
              return vim.fn.input("URL: ", "http://localhost:5173")
            end,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            userDataDir = false,
          },
        }
      end

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
