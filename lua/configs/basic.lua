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

require("image").setup({
  backend = "kitty",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    },
    neorg = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "norg" },
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = false,                                     -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  editor_only_render_when_focused = false,                                  -- auto show/hide images when the editor gains/looses focus
  tmux_show_only_in_active_window = false,                                  -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
})
