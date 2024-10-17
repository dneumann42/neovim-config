return {
  'alaviss/nim.nvim',
  'ziglang/zig.vim',
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()
      lsp_zero.on_attach(function(_client, bufnr)
        lsp_zero.default_keymaps({ bufnr = bufnr })

        local bindings = require('bindings')
        local lsp = bindings.lsp

        vim.keymap.set({ 'n', 'i' }, lsp.code_action, '<cmd>lua vim.lsp.buf.code_action()<CR>', { buffer = bufnr })
        vim.keymap.set('n', lsp.code_action2, '<cmd>lua vim.lsp.buf.code_action()<CR>', { buffer = bufnr })
        vim.keymap.set("n", lsp.rename, vim.lsp.buf.rename, { buffer = bufnr })

        local opts = { buffer = bufnr }

        vim.keymap.set('n', lsp.hover, "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("i", lsp.diagnostics, "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
        vim.keymap.set("n", lsp.diagnostics, '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
        vim.keymap.set('n', lsp.definition, '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', lsp.declaration, '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', lsp.implementation, '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', lsp.implementation, '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', lsp.references, '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', lsp.signature_help, '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', lsp.rename2, '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
      end)

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          lsp_zero.default_setup,
        },
      })

      local lspconfig = require('lspconfig')

      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }

      vim.api.nvim_create_augroup('AutoFormatting', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.lua',
        group = 'AutoFormatting',
        callback = function()
          vim.lsp.buf.format({ async = true })
        end,
      })

      vim.keymap.set({ "n" }, "<leader>F", function()
        vim.lsp.buf.format({ async = true })
      end)
    end
  },
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end
  },
  { "rafamadriz/friendly-snippets" },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-E>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
    end
  },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      }
    end
  }
}
