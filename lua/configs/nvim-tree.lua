require("nvim-tree").setup {

}

-- Open Nvim-Tree at startup
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    require('nvim-tree.api').tree.open()
  end
})
