local border = {
  { '┌', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '┐', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '┘', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '└', 'FloatBorder' },
  { '│', 'FloatBorder' },
}

local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border
  }),
}

vim.diagnostic.config({
  virtual_text = {
    prefix = '',
  },
  float = { border = 'single' },
})

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 53,
    opts = {
      ui = {
        border = "single"
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    priority = 52,
    opts = {
      ensure_installed = {
        "lua_ls",
      },
      automatic_installation = {
        exclude = {}
      }
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    lazy = false,
    priority = 51,
    opts = {
      servers = {
        lua_ls = {
          handlers = handlers,
          on_init = function(client)
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  "${3rd}/love2d/library"
                }
              }
            })
          end,
          settings = {
            Lua = {}
          }
        },
        nim_langserver = {
          handlers = handlers,
        },
        zls = {
          handlers = handlers,
        },
        ts_ls = {
          handlers = handlers
        },
        kotlin_language_server = {
          handlers = handlers
        },
        svelte = {
          handlers = handlers,
        },
        clangd = {
          handlers = handlers,
        },
      }
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      local bindings = require("config.keybindings")

      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP Actions',
        callback = function(event)
          local o = { buffer = event.buf }

          vim.keymap.set('n', bindings.lsp.hover, '<cmd>lua vim.lsp.buf.hover()<cr>', o)
          vim.keymap.set('n', bindings.lsp.definition, '<cmd>lua vim.lsp.buf.definition()<cr>', o)
          vim.keymap.set('n', bindings.lsp.declaration, '<cmd>lua vim.lsp.buf.declaration()<cr>', o)
          vim.keymap.set('n', bindings.lsp.implementation, '<cmd>lua vim.lsp.buf.implementation()<cr>', o)
          vim.keymap.set('n', bindings.lsp.type_definition, '<cmd>lua vim.lsp.buf.type_definition()<cr>', o)
          vim.keymap.set('n', bindings.lsp.references, '<cmd>lua vim.lsp.buf.references()<cr>', o)
          vim.keymap.set('n', bindings.lsp.signature_help, '<cmd>lua vim.lsp.buf.signature_help()<cr>', o)
          vim.keymap.set('n', bindings.lsp.rename, '<cmd>lua vim.lsp.buf.rename()<cr>', o)
          vim.keymap.set('n', bindings.lsp.format, '<cmd>lua vim.lsp.buf.format({async = true})<cr>', o)
          vim.keymap.set('n', bindings.lsp.code_action, '<cmd>lua vim.lsp.buf.code_action()<cr>', o)
          vim.keymap.set("n", bindings.lsp.diagnostics, vim.diagnostic.open_float)
        end
      })

      vim.keymap.set("n", bindings.diagnostic_next, vim.diagnostic.goto_next)
      vim.keymap.set("n", bindings.diagnostic_prev, vim.diagnostic.goto_prev)
    end
  },

  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "tsx" },
        auto_install = true,
        highlight = {
          enable = true,
        }
      }
    end,
  },

  -- https://cmp.saghen.dev/installation#lazy-nvim
  {
    'saghen/blink.cmp',
    version = "v0.10.0",
    opts = {
      keymap = {
        preset = 'default',
        ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
        ['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
        ['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
        ['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
        ['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
        ['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
        ['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
        ['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
        ['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
        ['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },

        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },

        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback'
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'path', 'buffer' }
      },
      completion = {
        ghost_text = { enabled = true },
      }
    },
  },
  opts_extend = { "sources.default" }
}
