local toggleterm = require("toggleterm")

toggleterm.setup {
  size = 10,
  open_mapping = [[<c-space>]],
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  close_on_exit = true,
  shell = vim.o.shell,
}

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<c-space>", [[<C-\><C-n> :ToggleTerm<cr>]], opts)
end

vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

-- show vifm in toggle terminal
local Terminal = require('toggleterm.terminal').Terminal

local vifm = Terminal:new { cmd = "vifm", hidden = true }

function _G.vifm_toggle()
  vifm:toggle(40)
end

vim.api.nvim_set_keymap("n", "<leader>v", "<cmd>lua vifm_toggle()<cr>", { noremap = true, silent = true })
