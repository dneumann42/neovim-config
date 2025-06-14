local lsp_servers = require("config.lsp-servers")
local mappings = require("config.mappings")

vim.lsp.config("*", {
	root_markers = { ".git" },
})

for k, v in pairs(lsp_servers) do
	vim.lsp.config[k] = v
	vim.lsp.enable(k)
end

local border = {
	{ "┌", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "┐", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "┘", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "└", "FloatBorder" },
	{ "│", "FloatBorder" },
}

-- vim.diagnostic.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
-- 	border = border,
-- })
-- vim.diagnostic.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
-- 	border = border,
-- })

vim.diagnostic.config({
	virtual_text = {
		prefix = "",
	},
	float = { border = "single" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP Actions",
	callback = function(event)
		local o = { buffer = event.buf }

		vim.keymap.set("n", mappings.lsp.hover, "<cmd>lua vim.lsp.buf.hover()<cr>", o)
		vim.keymap.set("n", mappings.lsp.definition, "<cmd>lua vim.lsp.buf.definition()<cr>", o)
		vim.keymap.set("n", mappings.lsp.declaration, "<cmd>lua vim.lsp.buf.declaration()<cr>", o)
		vim.keymap.set("n", mappings.lsp.implementation, "<cmd>lua vim.lsp.buf.implementation()<cr>", o)
		vim.keymap.set("n", mappings.lsp.type_definition, "<cmd>lua vim.lsp.buf.type_definition()<cr>", o)
		vim.keymap.set("n", mappings.lsp.references, "<cmd>lua vim.lsp.buf.references()<cr>", o)
		vim.keymap.set("n", mappings.lsp.signature_help, "<cmd>lua vim.lsp.buf.signature_help()<cr>", o)
		vim.keymap.set("n", mappings.lsp.rename, "<cmd>lua vim.lsp.buf.rename()<cr>", o)
		vim.keymap.set("n", mappings.lsp.format, "<cmd>lua vim.lsp.buf.format({async = true})<cr>", o)
		vim.keymap.set("n", mappings.lsp.code_action, "<cmd>lua vim.lsp.buf.code_action()<cr>", o)
		vim.keymap.set("n", mappings.lsp.diagnostics, vim.diagnostic.open_float)
	end,
})

vim.keymap.set("n", mappings.diagnostic_next, vim.diagnostic.goto_next)
vim.keymap.set("n", mappings.diagnostic_prev, vim.diagnostic.goto_prev)
