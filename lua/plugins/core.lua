return {
  "nvim-lua/plenary.nvim",
  'duane9/nvim-rg',
  {
    "kylechui/nvim-surround",
    opts = {}
  },
  {
    'm4xshen/autoclose.nvim',
    opts = {
      options = {
        disabled_filetypes = {
          "TelescopePrompt"
        },
        disable_command_mode = true,
      }
    }
  },
  { "folke/which-key.nvim", opts = {} },
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { cpp = true }, -- or { "cpp", }
      color = {
        suggestion_color = "#ffffff",
        cterm = 244,
      },
      log_level = "info",                -- set to "off" to disable logging completely
      disable_inline_completion = false, -- disables inline completion for use with cmp
      disable_keymaps = false,           -- disables built in keymaps for more manual control
      condition = function()
        return false
      end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
    }
  }
}
