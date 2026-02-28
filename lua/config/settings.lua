return {
  indentation = {
    value = 4,    
    lang = { nim = 2 }
  },

  colorscheme = {
    value = "catppuccin",
    clear_background = false,
  },

  mapleader = {
      value = ","
  },

  bindings = {
    eval_buffer                 = "<C-c>b",
    netrw_toggle                = "<space-M-0>",
    files_toggle                = "<M-0>",

    telescope_find_file         = "<leader>f",
    telescope_find_buffer       = "<leader>b",
    telescope_live_grep         = "<leader>g",
    telescope_help              = "<leader>h",

    toggle_terminal             = "<c-space>",
    neogit_status               = "<space>G",

    surround_add                = "sa",
    surround_delete             = "sd",
    surround_find               = "sf",
    surround_find_left          = "sF",
    surround_highlight          = "sh",
    surround_replace            = "cs",
    surround_suffix_last        = "l",
    surround_suffix_next        = "n",

    dropbar_pick                = "<leader>;",
    dropbar_goto_context_start  = "[;",
    dropbar_select_next_context = "];",

    lsp_definition              = "gd",
    lsp_declaration             = "gD",
    lsp_references              = "gr",
    lsp_implementation          = "gi",
    lsp_hover                   = "K",
    lsp_signature_help          = "<C-k>",
    lsp_rename                  = "grn",
    lsp_code_action             = "<A-CR>",
    lsp_document_symbol         = "gss",
    lsp_document_workspace      = "gsS",
    lsp_format                  = "gf",

    nim_diagnostics_float       = "<C-k>",
    nim_doc_float               = "<C-S-k>",

    split_unsplit = "<C-x>0",
    split_onlysplit = "<C-x>1",
    split_horizontal = "<C-x>2",
    split_vertical = "<C-x>3",
  },

  plugin_list = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "folke/snacks.nvim" },
    { "folke/which-key.nvim" },
    { "NeogitOrg/neogit" },
    { "nvim-mini/mini.surround" },
    { "nvim-mini/mini.files" },
    { "Bekaboo/dropbar.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
  },

  theme_list = {
    { "vague2k/vague.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "sontungexpt/witch" },
    { "folke/tokyonight.nvim" },
    { "catppuccin/nvim" },
  }
}

