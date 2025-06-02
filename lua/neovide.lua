local padding = 4

vim.opt.linespace = 0
vim.g.neovide_scale_factor = 1.0

vim.g.neovide_padding_top = padding
vim.g.neovide_padding_bottom = padding
vim.g.neovide_padding_right = padding
vim.g.neovide_padding_left = padding

local function alpha()
  return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
end

vim.g.neovide_opacity = 0.8
vim.g.transparency = 1.0
vim.g.neovide_background_color = "#0f1117" .. alpha()

vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
vim.g.neovide_floating_corner_radius = 0.2

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_animation_length = 0.0

local font_size = 10

local function update_font()
  vim.o.guifont = "Hurmit Nerd Font:h" .. font_size
end

update_font()

local M = {}

function M.set_font_size(new_size)
  font_size = new_size
  update_font()
end

vim.api.nvim_create_user_command("IncreaseFontSize", function()
  M.set_font_size(font_size + 1)
end, {})
vim.api.nvim_create_user_command("DecreaseFontSize", function()
  M.set_font_size(font_size - 1)
end, {})

vim.keymap.set("n", "<C-_>", function() vim.cmd("DecreaseFontSize") end,
  { buffer = true, desc = "Increase the font size" })

vim.keymap.set("n", "<C-+>", function() vim.cmd("IncreaseFontSize") end,
  { buffer = true, desc = "Increase the font size" })
