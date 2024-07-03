return {
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()
      lsp_zero.on_attach(function(client, bufnr)
        -- :help lsp-zero-keybindings
        lsp_zero.default_keymaps { bufnr = bufnr }

        vim.cmd [[
	    nnoremap <buffer> <M-CR> :lua vim.lsp.buf.code_action()<CR>
	    inoremap <buffer> <M-CR> :lua vim.lsp.buf.code_action()<CR>
	    inoremap <buffer> <leader>a :lua vim.lsp.buf.code_action()<CR>
	  ]]
      end)

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        },
      })

      vim.api.nvim_create_augroup('AutoFormatting', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.lua',
        group = 'AutoFormatting',
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  { 'L3MON4D3/LuaSnip' },
}
