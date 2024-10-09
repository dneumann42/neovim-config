return {
  {
    "kylechui/nvim-surround",
    config = function()
      require('nvim-surround').setup {}
    end
  },

  {
    'm4xshen/autoclose.nvim',
    config = function()
      require('autoclose').setup {
        options = {
          disabled_filetypes = {
            "TelescopePrompt"
          },
          disable_command_mode = true,
        }
      }
    end
  }
}
