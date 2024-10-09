vim.cmd [[
set colorcolumn=
set laststatus=3
]]

return {
  "dgox16/oldworld.nvim",
  "mofiqul/dracula.nvim",
  "tiagovla/tokyodark.nvim",
  "ntbbloodbath/sweetie.nvim",
  "yazeed1s/minimal.nvim",
  "rebelot/kanagawa.nvim",
  "NLKNguyen/papercolor-theme",

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  {
    "zaldih/themery.nvim",
    config = function()
      require("themery").setup {
        themes = { "oldworld", "dracula", "tokyodark", "sweetie", "minimal", "kanagawa", "catppuccin" },
        livePreview = true,
      }
    end
  },

  {
    'nvim-tree/nvim-web-devicons',
    color_icons = true,
    default = true,
    strict = true,
    config = function()
      require("nvim-tree").setup({
        update_cwd = true,
        update_focused_file = {
          enable = true,
          update_cwd = true
        },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {
        options = {
          theme = require("linetheme").theme(),
          component_separators = '',
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { { 'mode', separator = { left = '▒' }, right_padding = 2 } },
          lualine_b = { 'filename', 'branch', 'diff', 'diagnostics' },
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
  },

  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        -- table: default groups
        groups = {
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
          'EndOfBuffer',
        },
        -- table: additional groups that should be cleared
        extra_groups = {
          "NormalFloat",    -- plugins which have float panel such as Lazy, Mason, LspInfo
          "NvimTreeNormal", -- NvimTree
          "TelescopeNormal",
          "TelescopeBorder",
        },
        -- table: groups you don't want to clear
        exclude_groups = {},
        -- function: code to be executed after highlight groups are cleared
        -- Also the user event "TransparentClear" will be triggered
        on_clear = function() end,
      })

      vim.g.transparent_enabled = true
    end
  },
}
