return {
  "nvim-lua/plenary.nvim",
  {
    "folke/which-key.nvim",
    config = function()
      require('which-key').setup {}
    end
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
    config = function()
      require('dressing').setup {}
    end
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require('nvim-surround').setup {}
    end
  },
  {
    'm4xshen/autoclose.nvim',
    config = function()
      require('autoclose').setup {}
    end
  },
}
