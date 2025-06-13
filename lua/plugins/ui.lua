return {
	{
		"echasnovski/mini.completion",
		version = "*",
		opts = {
			delay = { completion = 100, info = 100, signature = 50 },
		},
		config = function(_, opts)
			require("mini.completion").setup(opts)
		end,
	},
	{
		"echasnovski/mini.icons",
		version = "*",
		opts = {},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mini.icons",
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}},
		},
		lazy = false,
		opts = {},
	},
}
