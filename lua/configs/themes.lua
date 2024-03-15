local settings = require("settings")

require("colorizer").setup { '*', }

if settings.get("colorscheme") then
  vim.cmd("colorscheme " .. settings.get("colorscheme"))
end

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = 'auto',
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },      -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
  -- mode component
  function()
    return ''
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}

ins_left {
  -- filesize component
  'filesize',
  cond = conditions.buffer_not_empty,
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'location' }

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}

ins_left {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}

-- Add components to right sections
ins_right {
  'o:encoding',       -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)

-- Theme switching and preview
require("themery").setup({
  themes = require("settings/themes"),
  themeConfigFile = "~/.config/nvim/lua/settings/theme.lua", -- Described below
  livePreview = true,                                        -- Apply theme while browsing. Default to true.
})

require("catppuccin").setup {
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  -- background = {     -- :h background
  --   light = "latte",
  --   dark = "mocha",
  -- },
  transparent_background = true, -- disables setting the background color.
  show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
  term_colors = true,            -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false,             -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15,           -- percentage of the shade to apply to the inactive window
  },
  no_italic = false,             -- Force no italic
  no_bold = false,               -- Force no bold
  no_underline = false,          -- Force no underline
  styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" },     -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = { "bold" },
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  highlight_overrides = {
    mocha = function()
      return {

      }
    end
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = true,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    telescope = true,
    which_key = true,
  },
}

require("transparent").setup {
  enabled = true,
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  extra_groups = {},   -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
}

vim.cmd [[ TransparentEnable ]]

-- Dressing config

require("dressing").setup({
  input = {
    -- Set to false to disable the vim.ui.input implementation
    enabled = true,

    -- Default prompt string
    default_prompt = "Input",

    -- Trim trailing `:` from prompt
    trim_prompt = true,

    -- Can be 'left', 'right', or 'center'
    title_pos = "left",

    -- When true, <Esc> will close the modal
    insert_only = true,

    -- When true, input will start in insert mode.
    start_in_insert = true,

    -- These are passed to nvim_open_win
    border = "rounded",
    -- 'editor' and 'win' will default to being centered
    relative = "cursor",

    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    prefer_width = 40,
    width = nil,
    -- min_width and max_width can be a list of mixed types.
    -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
    max_width = { 140, 0.9 },
    min_width = { 20, 0.2 },

    buf_options = {},
    win_options = {
      -- Disable line wrapping
      wrap = false,
      -- Indicator for when text exceeds window
      list = true,
      listchars = "precedes:…,extends:…",
      -- Increase this for more context when text scrolls off the window
      sidescrolloff = 0,
    },

    -- Set to `false` to disable
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
      },
    },

    override = function(conf)
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      return conf
    end,

    -- see :help dressing_get_config
    get_config = nil,
  },
  select = {
    -- Set to false to disable the vim.ui.select implementation
    enabled = true,

    -- Priority list of preferred vim.select implementations
    backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

    -- Trim trailing `:` from prompt
    trim_prompt = true,

    -- Options for telescope selector
    -- These are passed into the telescope picker directly. Can be used like:
    -- telescope = require('telescope.themes').get_ivy({...})
    telescope = nil,

    -- Options for fzf selector
    fzf = {
      window = {
        width = 0.5,
        height = 0.4,
      },
    },

    -- Options for fzf-lua
    fzf_lua = {
      -- winopts = {
      --   height = 0.5,
      --   width = 0.5,
      -- },
    },

    -- Options for nui Menu
    nui = {
      position = "50%",
      size = nil,
      relative = "editor",
      border = {
        style = "rounded",
      },
      buf_options = {
        swapfile = false,
        filetype = "DressingSelect",
      },
      win_options = {
        winblend = 0,
      },
      max_width = 80,
      max_height = 40,
      min_width = 40,
      min_height = 10,
    },

    -- Options for built-in selector
    builtin = {
      -- Display numbers for options and set up keymaps
      show_numbers = true,
      -- These are passed to nvim_open_win
      border = "rounded",
      -- 'editor' and 'win' will default to being centered
      relative = "editor",

      buf_options = {},
      win_options = {
        cursorline = true,
        cursorlineopt = "both",
      },

      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- the min_ and max_ options can be a list of mixed types.
      -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
      width = nil,
      max_width = { 140, 0.8 },
      min_width = { 40, 0.2 },
      height = nil,
      max_height = 0.9,
      min_height = { 10, 0.2 },

      -- Set to `false` to disable
      mappings = {
        ["<Esc>"] = "Close",
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
      },

      override = function(conf)
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        return conf
      end,
    },

    -- Used to override format_item. See :help dressing-format
    format_item_override = {},

    -- see :help dressing_get_config
    get_config = nil,
  },
})
