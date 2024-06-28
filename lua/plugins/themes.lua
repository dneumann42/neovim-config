return {
  "dgox16/oldworld.nvim",
  "mofiqul/dracula.nvim",
  "tiagovla/tokyodark.nvim",
  "ntbbloodbath/sweetie.nvim",
  "yazeed1s/minimal.nvim",

  {
    "zaldih/themery.nvim",
    config = function()
      require("themery").setup {
        themes = { "oldworld", "dracula", "tokyodark", "sweetie", "minimal" },
        livePreview = true,
        themeConfigFile = os.getenv("HOME") .. "/.config/nvim/lua/theme.lua",
      }
    end
  },

  {
    'nvim-tree/nvim-web-devicons',
    color_icons = true,
    default = true,
    strict = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {
        options = {
          component_separators = '',
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { { 'mode', separator = { left = '▒' }, right_padding = 2 } },
          lualine_b = { 'filename', 'branch' },
          lualine_c = {
            '%=', --[[ add your center compoentnts here in place of this comment ]]
          },
          lualine_x = {},
          lualine_y = { 'filetype', 'progress' },
          lualine_z = {
            { 'location', separator = { right = '▒' }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        tabline = {},
        extensions = {},
      }
    end
  }
}
