function _G.map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function _G.nmap(shortcut, command)
  map('n', shortcut, command)
end

function _G.imap(shortcut, command)
  map('i', shortcut, command)
end
