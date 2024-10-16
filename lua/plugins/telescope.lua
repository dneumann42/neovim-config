return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<space><space>', builtin.find_files, {})

      vim.keymap.set('n', '<space>g', builtin.live_grep, {})

      vim.keymap.set('n', '<space>b', builtin.buffers, {})
      vim.keymap.set('n', '<space>h', builtin.help_tags, {})

      vim.keymap.set('n', '<leader>f', builtin.find_files, {})
      vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
      vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
    end
  }
}
