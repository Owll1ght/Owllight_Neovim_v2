-- Godot Debugging
-- Write breakpoint to new line
if vim.bo.filetype == "gdscript" then
	vim.api.nvim_create_user_command("GodotBreakpoint", function()
		vim.cmd("normal! obreakpoint")
		vim.cmd("write")
	end, {})
	vim.keymap.set("n", "<leader>jb", ":GodotBreakpoint<CR>", { desc = "Write Godot Breakpoint" })

	-- Delete all breakpoints in current File
	vim.api.nvim_create_user_command("GodotDeteleteBreakpoint", function()
		vim.cmd("g/breakpoin/d")
	end, {})
	vim.keymap.set("n", "<leader>jd", ":GodotDeteleteBreakpoint<CR>", { desc = "Delete All Godot Breakpoints" })

	-- Search all breakpoints in project
	vim.api.nvim_create_user_command("GodotFindBreakpoints", function()
		vim.cmd(":grep breakpoint | copen")
	end, {})
	vim.keymap.set("n", "<leader>jf", ":GodotFindBreakpoints<CR>", { desc = "Search Breakpoints" })

	-- append "# TRANSLATORS: " to current line
	vim.api.nvim_create_user_command("GodotTranslator", function(opts)
		vim.cmd("normal! A # TRANSLATORS: ")
	end, {})
	vim.keymap.set("n", "<leader>ja", ":GodotTranslator<CR>", { desc = "Godot Translator" })
end
