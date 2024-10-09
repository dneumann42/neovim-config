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
    -- config = function()
    --   require('dressing').setup {}
    -- end
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

  {
    'notjedi/nvim-rooter.lua',
    config = function()
      require('nvim-rooter').setup {
        rooter_patterns = { '.git', '.hg', '.svn' },
        trigger_patterns = { '*' },
        manual = false,
        fallback_to_parent = false,
      }
    end
  }
}
