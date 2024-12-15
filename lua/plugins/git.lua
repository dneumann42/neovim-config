return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {},
  config = function(_, opts)
    require("neogit").setup(opts)
    local bindings = require('config.keybindings')
    vim.keymap.set('n', bindings.git.status, '<cmd>Neogit<cr>')
    vim.keymap.set('n', bindings.git.commit, '<cmd>Neogit commit<cr>')
  end
}
