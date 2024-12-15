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
  { "folke/which-key.nvim", opts = {} }
}
