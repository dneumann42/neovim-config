-- Thanks to https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- for making this so easy

local M = {}

M.plugins = {
  ui = {
    border = "double",
    size = {
      width = 0.8,
      height = 0.8,
    },
  },

  -- git plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth
  'tpope/vim-sleuth',

  -- autocompletion for vim config
  { "folke/neodev.nvim",      opts = {} },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Gutters
  { 'lewis6991/gitsigns.nvim' },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Startup and sessions
  { 'echasnovski/mini.sessions', version = '*' },
  { 'echasnovski/mini.starter',  version = '*' },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  { "norcalli/nvim-colorizer.lua" },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} }, -- indent lines

  -- themes
  { "savq/melange-nvim" },
  { "rebelot/kanagawa.nvim" },
  { "kepano/flexoki" },
  { "zaldih/themery.nvim" },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin"
  },
  -- { "xiyaowong/transparent.nvim" },
  {
    "ziontee113/icon-picker.nvim",
    config = function()
      require("icon-picker").setup({ disable_legacy_commands = true })

      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<Leader><Leader>i", "<cmd>IconPickerNormal<cr>", opts)
      vim.keymap.set("n", "<Leader><Leader>y", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
      vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
    end
  },

  -- Improves vim.ui
  { 'stevearc/dressing.nvim' },

  -- Discovery and help
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  { "chentoast/marks.nvim" },
  { "folke/which-key.nvim" },

  -- Utility
  { "kylechui/nvim-surround" },
  { "m4xshen/autoclose.nvim" },
  { "terrortylor/nvim-comment" },
  { "rktjmp/fwatch.nvim" },
  { "rcarriga/nvim-notify" },

  -- terminal
  { "akinsho/toggleterm.nvim" },
  -- terminal image support (requires kitty)
  -- { "3rd/image.nvim" },

  -- lisp
  { "monkoose/parsley" }, -- utility library required by nvlime
  { "monkoose/nvlime" },

  -- web tech
  { "jparise/vim-graphql" },

  -- my own plugins
  { "dneumann42/nvim-wikid" }
}

M.bootstrap = function()
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
end

return M
