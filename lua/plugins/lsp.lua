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
        }
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
    'saghen/blink.cmp',
    lazy = false,
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.8.1',
    opts = {
      keymap = {
        preset = 'default',
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
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- Enables keymaps, completions and signature help when true
      enabled = function() return vim.bo.buftype ~= "prompt" end,

      snippets = {
        -- Function to use when expanding LSP provided snippets
        expand = function(snippet) vim.snippet.expand(snippet) end,
        -- Function to use when checking if a snippet is active
        active = function(filter) return vim.snippet.active(filter) end,
        -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
        jump = function(direction) vim.snippet.jump(direction) end,
      },

      completion = {
        menu = {
          enabled = true,
          min_width = 15,
          max_height = 10,
          border = 'single',
          winblend = 0,
          winhighlight =
          'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        }
      }

      -- signature = { enabled = true }
    },
    opts_extend = { "sources.default" },
    init = function()
      vim.cmd [[ hi Pmenu ctermbg=NONE guibg=NONE ]]
    end
  }
}
