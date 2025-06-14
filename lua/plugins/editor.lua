return {
	{
		"echasnovski/mini.sessions",
		version = "*",
		opts = {
			autoread = true,
			autowrite = true,
			directory = os.getenv("HOME") .. "/.local/state/nvim/sessions/",
			file = "Session.vim",
			force = { read = false, write = true, delete = false },
			hooks = {
				pre = { read = nil, write = nil, delete = nil },
				post = { read = nil, write = nil, delete = nil },
			},
			verbose = { read = false, write = true, delete = true },
		},
		config = function(_, opts)
			require("mini.sessions").setup(opts)
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("nvim-surround").setup(opts)
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			scope = {
				enabled = false,
			},
			indent = {
				char = "▏",
			},
		},
	},

	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {
			builtin_marks = { ".", "<", ">", "^" },
		},
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {},
		config = function(_, opts)
			require("neogit").setup(opts)
			local bindings = require("config.mappings")
			vim.keymap.set("n", bindings.git.status, "<cmd>Neogit<cr>")
			vim.keymap.set("n", bindings.git.commit, "<cmd>Neogit commit<cr>")
		end,
	},
}
