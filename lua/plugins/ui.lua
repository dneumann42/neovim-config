return {
  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  { 'stevearc/dressing.nvim', opts = {}, },

  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    opts = {},
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      use_libuv_file_watcher = true,
      close_if_last_window = true,
      popup_border_style = "single",
      follow_current_file = {
        enabled = true
      },
      window = {
        position = "left",
        width = 40,
        mappings = {
          ["P"] = {
            "toggle_preview",
            config = {
              use_float = true,
              use_image_nvim = false
            }
          }
        }
      },
      filesystem = {
        -- I manually handle this behavior
        hijack_netrw_behavior = "disabled"
      },
      default_component_configs = {
        diagnostics = {
          symbols = {
            hint = "󰌵",
            info = " ",
            warn = " ",
            error = " ",
          },
          highlights = {
            hint = "DiagnosticSignHint",
            info = "DiagnosticSignInfo",
            warn = "DiagnosticSignWarn",
            error = "DiagnosticSignError",
          },
        },
        git_status = {
          symbols = {
            -- Change type
            added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted   = "✖", -- this can only be used in the git_status source
            renamed   = "󰁕", -- this can only be used in the git_status source
            -- Status type
            untracked = "",
            ignored   = "",
            unstaged  = "",
            staged    = "",
            conflict  = "",
          }
        },
      },
    },
    config = function(_, opts)
      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "󰌵",
          }
        }
      }
      require('neo-tree').setup(opts)
    end,
    init = function()
      local bindings = require("config.keybindings")

      vim.keymap.set('n', bindings.toggle_sidebar, function()
        vim.cmd "Neotree toggle reveal=true"
      end)

      -- ensure neotree stays left when moving splits
      local function is_neotree_open()
        for _, win_id in ipairs(vim.api.nvim_list_wins()) do
          local buf_id = vim.api.nvim_win_get_buf(win_id)
          local buf_name = vim.api.nvim_buf_get_name(buf_id)
          if string.find(buf_name, 'neo%-tree') then
            return true
          end
        end
        return false
      end

      local function wincmd_H()
        local toggle = is_neotree_open()
        if toggle then vim.cmd [[ Neotree toggle ]] end
        vim.cmd [[ wincmd H ]]
        if toggle then
          local current_win = vim.api.nvim_get_current_win() -- Get current window ID
          vim.cmd [[ Neotree toggle ]]
          vim.api.nvim_set_current_win(current_win)
        end
      end

      vim.keymap.set('n', '<C-w>H', wincmd_H)

      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          local arg0 = vim.fn.argv(0)
          if vim.fn.isdirectory(arg0) == 1 then
            if type(arg0) == "string" then
              vim.fn.chdir(arg0)
            end

            vim.cmd [[ Neotree position=current ]]
          end
        end,
      })
    end,
  },

  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
        }
      }
    }
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    opts = {
      defaults = {
        layout_config = {
          vertical = { width = 0.5 }
        }
      },
      pickers = {
        find_files = {
          theme = "dropdown"
        },
        live_grep = {
          theme = "dropdown"
        }
      },
      extensions = {
        live_grep_args = {
          theme = "dropdown"
        }
      }
    },
    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension("live_grep_args")

      local bindings = require('config.keybindings')
      local builtin = require('telescope.builtin')

      vim.keymap.set('n', bindings.telescope.find_files, builtin.find_files, {})
      vim.keymap.set('n', bindings.telescope.live_grep, function()
        require("telescope").extensions.live_grep_args.live_grep_args {
          theme = "dropdown"
        }
      end, {})
      vim.keymap.set('n', bindings.telescope.buffers, builtin.buffers, {})
      vim.keymap.set('n', bindings.telescope.help_tags, builtin.help_tags, {})

      vim.keymap.set('n', bindings.telescope.find_files2, builtin.find_files, {})
      vim.keymap.set('n', bindings.telescope.buffers2, builtin.buffers, {})
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = {
        enabled = false
      },
      indent = {
        char = '▏'
      }
    },
  },

  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      builtin_marks = { ".", "<", ">", "^" },
    }
  }
}
