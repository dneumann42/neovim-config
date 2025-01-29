return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup {
        transparent = false,
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
    end
  }
}
