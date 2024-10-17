return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },

    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_config = {
            vertical = { width = 0.5 }
          }
        },
        pickers = {
          find_files = {
            theme = "dropdown"
          },
          live_grep = {
            theme = "dropdown"
          }
        },
        extensions = {
          live_grep_args = {
            theme = "dropdown"
          }
        }
      }

      require('telescope').load_extension("live_grep_args")

      local builtin = require('telescope.builtin')
      local bindings = require('bindings')
      vim.keymap.set('n', bindings.telescope.find_files, builtin.find_files, {})
      vim.keymap.set('n', bindings.telescope.live_grep, function()
        require("telescope").extensions.live_grep_args.live_grep_args {
          theme = "dropdown"
        }
      end, {})
      vim.keymap.set('n', bindings.telescope.buffers, builtin.buffers, {})
      vim.keymap.set('n', bindings.telescope.help_tags, builtin.help_tags, {})

      vim.keymap.set('n', bindings.telescope.find_files2, builtin.find_files, {})
      vim.keymap.set('n', bindings.telescope.live_grep2, builtin.live_grep, {})
      vim.keymap.set('n', bindings.telescope.buffers2, builtin.buffers, {})
    end
  }
}
