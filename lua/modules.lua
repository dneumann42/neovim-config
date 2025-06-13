require("tools")

local mappings = require("config.mappings")

_G.eval = function(code)
	local result = vim.api.nvim_exec2("silent! source %", { output = true })
	if result.output then
		vim.tools.show_cursor_message(vim.tools.split_lines(result.output))
	end
	if result.error then
		local info = vim.tools.split_lines(result.error)
		table.insert(info, 1, "ERROR:")
		vim.tools.show_cursor_message(info)
	end
end

vim.api.nvim_create_user_command("Eval", function()
	local code = vim.tools.get_buffer_contents()
	local ok, value = eval(code)
end, {})

vim.keymap.set("n", mappings.evaluate_buffer, ":Eval<cr>")
