local lsp_servers = require("config.lsp-servers")

vim.lsp.config["luals"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
		},
	},
}

for i = 1, #lsp_servers do
	vim.lsp.enable(lsp_servers[i])
end
