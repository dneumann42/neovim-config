local transparent = true

local themes = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    transparent_background = transparent,
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    transparent = transparent,
    styles = {
      sidebars = transparent and "transparent" or nil,
      floats = transparent and "transparent" or nil,
    },
    style = "moon",
    on_highlights = function(hl, c)
      hl.TelescopeNormal = {
        bg = 'none',
        fg = c.fg_dark,
      }
      hl.TelescopeBorder = {
        bg = 'none',
        fg = c.fg_dark,
      }
      hl.TelescopePromptNormal = {
        bg = 'none',
        fg = c.fg_dark,
      }
      hl.TelescopePromptBorder = {
        bg = 'none',
        fg = c.fg_dark,
      }
      hl.TelescopePromptTitle = {
        bg = 'none',
        fg = c.fg_dark,
      }
      hl.TelescopePreviewTitle = {
        bg = 'none',
        fg = c.fg_dark,
      }
      hl.TelescopeResultsTitle = {
        bg = 'none',
        fg = c.fg_dark,
      }
    end,
  }
}

local theme_options = {}

local plugins = {}
for i = 1, #themes do
  local plug = { themes[i][1], opts = {} }
  for k, v in pairs(themes[i]) do
    plug.opts[k] = v
  end
  plug.lazy = false
  plug.priority = 1000
  plug.config = function(_, opts)
    require(plug.opts.name).setup(opts)
  end
  table.insert(theme_options, plug.opts.name)
  table.insert(plugins, plug)
end

local function change_theme()
  vim.ui.select(theme_options, {}, function(item)
    if not item then
      return
    end
    vim.cmd(string.format("colorscheme %s", item))
  end)
end

vim.api.nvim_create_user_command("SwitchTheme", change_theme, {})

return plugins
