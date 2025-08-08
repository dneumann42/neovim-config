local Git = {}

function Git.configure()
    require("neogit").setup {}
    vim.keymap.set('n', '<space>gs', '<cmd>Neogit<cr>')
    vim.keymap.set('n', '<space>gc', '<cmd>Neogit commit<cr>')
end

Git.configure()

return Git
