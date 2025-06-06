return {
  toggle_sidebar = '<space>e',
  commands = {
    run = "<F5>",
    select = "<F6>",
    new = "<F7>",
  },
  write = "<leader>w",
  quit_all = "<leader>Q",
  quit = "<leader>q",
  clear_highlight = "<leader>c",
  diagnostic_next = ']g',
  diagnostic_prev = '[g',
  git = {
    status = '<space>gg',
    commit = '<space>gc',
  },
  split = {
    horizontal = '<C-x>2',
    vertical = '<C-x>3',
  },
  tab = {
    new = '<leader>tt',
    next = '<leader>tn',
    prev = '<leader>tp',
    close = '<leader>tx',
  },
  lsp = {
    hover = 'K',
    diagnostics = '<C-K>',
    code_action = '<M-CR>',
    rename = '<leader>r',
    definition = 'gd',
    declaration = 'gD',
    implementation = 'gi',
    type_definition = 'go',
    references = 'gr',
    signature_help = 'gs',
    format = '<leader>F'
  },
  telescope = {
    find_files = '<space><space>',
    find_files2 = '<leader>f',
    live_grep = '<leader>g',
    buffers = '<space>b',
    buffers2 = '<leader>b',
    help_tags = '<space>h',
  },
  terminal = {
  },
  maindo = {
    execute = "<F2>",
  }
}
