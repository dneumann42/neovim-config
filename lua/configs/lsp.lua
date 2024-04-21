require('neodev').setup()

local cmp = require("cmp")
local luasnip = require("luasnip")

require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

local servers = {
  lua_ls = {

  },
  -- nim_langserver = {

  -- },
  -- rust_analyzer = {

  -- },
  -- pylsp = {

  -- },
  -- tsserver = {
  --   filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  --   cmd = { "typescript-language-server", "--stdio" }
  -- },
  -- graphql = {
  --   cmd = { "graphql-lsp", "server", "-m", "stream" },
  --   filetypes = { "graphql", "typescriptreact", "javascriptreact" }
  -- }
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

--  This function gets run when an LSP connects to a particular buffer.
local function on_attach(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format()
    end,
  })

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('<a-cr>', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>os', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[O] Workspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-S-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>oa', vim.lsp.buf.add_workspace_folder, '[O] Workspace [A]dd Folder')
  nmap('<leader>or', vim.lsp.buf.remove_workspace_folder, '[O] Workspace [R]emove Folder')
  nmap('<leader>ol', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[O] Workspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
  ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })


lspconfig.lua_ls.setup {
}

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

for _, server_name in ipairs(vim.tbl_keys(servers)) do
  require('lspconfig')[server_name].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = servers[server_name],
    filetypes = (servers[server_name] or {}).filetypes,
  }
end

require 'lspconfig'.nim_langserver.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

cmp.setup.filetype({ 'lisp' }, {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvlime' },
  },
})

vim.cmd [[
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
let g:neoformat_enabled_nim = ['nph']
]]
