return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require('dap')
      dap.adapters = {
        gdb = {
          type = "executable",
          command = "gdb",
          args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
        }
      }

      dap.configurations = {
        cpp = {
          {
            name = "Launch",
            type = "gdb",
            request = "launch",
            program = function()
              return vim.fn.input("Executable: ", vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = "${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
          }
        }
      }

      vim.keymap.set('n', '<f9>', function() dap.continue() end)
      vim.keymap.set('n', '<f10>', function() dap.step_over() end)
      vim.keymap.set('n', '<f11>', function() dap.step_into() end)
      vim.keymap.set('n', '<f12>', function() dap.step_out() end)

      vim.keymap.set('n', '<leader>db', function()
        dap.toggle_breakpoint()
      end)
      vim.keymap.set('n', '<leader>dB', function()
        dap.set_breakpoint()
      end)
      vim.keymap.set('n', '<leader>dk', function()
        dap.terminate()
      end)
      vim.keymap.set('n', '<leader>dr', function()
        dap.repl.open()
      end)
      vim.keymap.set('n', '<leader>dl', function()
        dap.repl.run_last()
      end)
      vim.keymap.set({ 'n', 'v' }, '<leader>dp', function()
        require('dap.ui.widgets').preview()
      end)
      vim.keymap.set('n', '<leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end)
      vim.keymap.set('n', '<leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
      end)
    end,
  },
}
