local fmt = string.format

vim.g.mapleader = ','
vim.g.maplocalleader = ','
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.cmd [[
set clipboard+=unnamedplus
set number
set autoread

au BufNewFile,BufRead *.owl set filetype=owl
au Syntax *.owl runtime! syntax/owl.vim
]]

require("nvim-surround").setup {}
require("nvim_comment").setup {}
require("autoclose").setup {}

require("notify").setup {
  background_colour = "#000000",
}

local settings = require("settings")

local function set_tab_size(tabs)
  vim.opt.tabstop = tabs
  vim.opt.shiftwidth = tabs
  vim.opt.expandtab = true
end

if settings.get("tabs") then
  set_tab_size(settings.get("tabs"))
end

settings.on_key_change("tabs", vim.schedule_wrap(function(_, tabs)
  set_tab_size(tabs)
end))
