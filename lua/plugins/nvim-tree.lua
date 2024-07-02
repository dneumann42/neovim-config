return {
  {
    "nvim-tree/nvim-tree.lua",
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("nvim-tree").setup {
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
          adaptive_size = true
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
        auto_reload_on_write = true,
        hijack_cursor = true,
      }

      local api = require "nvim-tree.api"
      vim.keymap.set('n', '<space>e', api.tree.toggle, {
        silent = true,
        desc = "toggle nvim-tree",
      })
      vim.keymap.set('n', '<leader>e', api.tree.toggle, {
        silent = true,
        desc = "toggle nvim-tree",
      })
    end
  }
}
