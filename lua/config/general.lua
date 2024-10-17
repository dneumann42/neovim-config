local tab_size = 2

if vim.g.neovide then
  vim.o.guifont = "FiraCode Nerd Font Mono:h12"
  local p = 8
  vim.g.neovide_padding_top = p
  vim.g.neovide_padding_bottom = p
  vim.g.neovide_padding_right = p
  vim.g.neovide_padding_left = p
  vim.g.neovide_frame = "none"
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_trail_size = 0.8
  vim.g.neovide_refresh_rate_idle = 1
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_scroll_animation_length = 0.1
end

vim.opt.showmatch = true
vim.opt.shiftwidth = tab_size
vim.opt.tabstop = tab_size
vim.opt.softtabstop = tab_size
vim.opt.expandtab = true

-- custom tab size autocommands
vim.cmd [[
autocmd FileType cs setlocal shiftwidth=4 softtabstop=4 expandtab
]]

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.wildmode = "longest,list"
vim.opt.cc = "120"

vim.g.mouse = "v"
vim.g.mapleader = ","

vim.cmd [[ filetype plugin indent on ]]
vim.cmd [[ filetype plugin on ]]
vim.cmd [[ syntax on ]]

vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.opt.clipboard = "unnamedplus"
vim.opt.ttyfast = true
vim.opt.swapfile = true
vim.opt.backupdir = os.getenv("HOME") .. "/.cache/vim"

local bindings = require("bindings")
vim.keymap.set('n', bindings.write, ':w<cr>')
vim.keymap.set('n', bindings.quit_all, ':qa!<cr>')
vim.keymap.set('n', bindings.quit, ':q!<cr>')
vim.keymap.set('n', bindings.clear_highlight, ':noh<cr>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', bindings.split.horizontal, ':split<cr>')
vim.keymap.set('n', bindings.split.vertical, ':vsplit<cr>')

vim.cmd [[ au TextYankPost * silent! lua vim.highlight.on_yank() ]]

vim.cmd [[ au BufRead,BufNewFile *.asha set filetype=asha ]]
vim.cmd [[ au BufRead,BufNewFile *.owl set filetype=owl ]]

-- tabs
vim.keymap.set('n', bindings.tab.new, ':tabnew<cr>')
vim.keymap.set('n', bindings.tab.next, ':tabnext<cr>')
vim.keymap.set('n', bindings.tab.prev, ':tabprevious<cr>')
vim.keymap.set('n', bindings.tab.close, ':tabclose<cr>')

local function clear_background_color()
  vim.cmd "highlight Normal guibg=none"
  vim.cmd "highlight NonText guibg=none"
  vim.cmd "highlight Normal ctermbg=none"
  vim.cmd "highlight NonText ctermbg=none"
  vim.cmd "highlight LineNr ctermbg=none"
  vim.cmd "highlight LineNr guibg=none"
  vim.cmd "highlight TelescopeBorder ctermbg=none"
  vim.cmd "highlight FloatBorder ctermbg=none"
  vim.cmd "highlight TelescopeBorder guibg=none"
  vim.cmd "highlight FloatBorder guibg=none"
  vim.cmd "highlight SignColumn guibg=none"
  vim.cmd "highlight SignColumn ctermbg=none"
end

vim.api.nvim_create_user_command("ClearBackgroundColor", clear_background_color, {})
vim.api.nvim_create_autocmd('ColorScheme', { callback = clear_background_color })
