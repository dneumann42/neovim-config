vim.tools = vim.tools or {}
vim.tools.get_buffer_contents = function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	return table.concat(lines, "\n")
end

vim.tools.split_lines = function(str)
	local lines = {}
	for line in string.gmatch(str, "([^\n]+)") do
		table.insert(lines, line)
	end
	return lines
end

vim.tools.show_cursor_message = function(msg)
	local info_text = type(msg) == "table" and msg or vim.tools.split_lines(msg)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, info_text)

	local win = vim.api.nvim_open_win(buf, false, {
		relative = "cursor",
		row = 0,
		col = 2,
		width = 60,
		height = math.max(#info_text, 1),
		style = "minimal",
	})

	vim.api.nvim_create_autocmd("CursorMoved", {
		callback = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})
end
