return {
  dashboard = {
    show = "<space>D",
  },
  commands = {
    run = "<F5>",
    select = "<F6>",
    new = "<F7>",
  },
  write = "<leader>w",
  quit_all = "<leader>Q",
  quit = "<leader>q",
  clear_highlight = "<leader>c",

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
  telescope = {
    find_files = '<space><space>',
    find_files2 = '<leader>f',
    live_grep = '<space>g',
    live_grep2 = '<leader>g',
    buffers = '<space>b',
    buffers2 = '<leader>b',
    help_tags = '<space>h',
  },
  lsp = {
    hover = 'K',
    diagnostics = '<C-K>',
    code_action = '<M-CR>',
    code_action2 = '<leader>a',
    rename = '<leader>r',
    rename2 = '<F2>',
    definition = 'gd',
    declaration = 'gD',
    implementation = 'gi',
    type_definition = 'go',
    references = 'gr',
    signature_help = 'gs',
  }
}
