local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

local my_formats = {
	c = { "clang-format" },
	cpp = { "clang-format" },
	cs = { "csharpier", "clang-format", stop_after_first = true },
	lua = { "stylua" },
	go = { "goimports" },
	rust = { "rustfmt" },
	java = { "clang-format" },
	python = { "black" },
	odin = { "odinfmt" },
	json = { "biome", "prettier", stop_after_first = true },
	markdown = { "prettier" },
	javascript = { "biome", "prettier", stop_after_first = true },
	typescript = { "biome", "prettier", stop_after_first = true },
	javascriptreact = { "biome", "prettier", stop_after_first = true },
	typescriptreact = { "biome", "prettier", stop_after_first = true },
	css = { "prettier" },
	html = { "prettier" },
	toml = { "taplo" },
}

local my_windows_overrides = {}

if is_windows then
	local tools =
		{ "odin", "clang-format", "csharpier", "stylua", "goimports", "rustfmt", "black", "biome", "prettier", "taplo" }
	local mason_packages = vim.fn.stdpath("data") .. "/mason/packages/"

	for _, fmt in pairs(tools) do
		local path_root_exe = mason_packages .. fmt .. "/" .. fmt .. ".exe"
		local path_root = mason_packages .. fmt .. "/" .. fmt
		local path_bin_exe = mason_packages .. fmt .. "/bin/" .. fmt .. ".exe"
		local path_bin = mason_packages .. fmt .. "/bin/" .. fmt

		if vim.fn.filereadable(path_root_exe) == 1 then
			my_windows_overrides[fmt] = { command = path_root_exe }
		elseif vim.fn.filereadable(path_bin_exe) == 1 then
			my_windows_overrides[fmt] = { command = path_bin_exe }
		elseif vim.fn.filereadable(path_root) == 1 then
			my_windows_overrides[fmt] = { command = path_root }
		elseif vim.fn.filereadable(path_bin) == 1 then
			my_windows_overrides[fmt] = { command = path_bin }
		end
	end
end

require("conform").setup({
	formatters_by_ft = my_formats,
	formatters = my_windows_overrides,
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = function(bufnr)
		local ignore_filetypes = { "sql", "yaml", "yml" }
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/node_modules/") then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(opts)
	if opts.bang then
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
	vim.notify("Autoformat disable" .. (opts.bang and " (buffer) " or " (global) "), vim.log.levels.WARN)
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
	vim.notify("Autoformat enabled", vim.log.levels.INFO)
end, { desc = "Re-enable autoformat-on-save" })

local auto_format = true

vim.keymap.set("n", "<leader>uf", function()
	auto_format = not auto_format
	if auto_format then
		vim.cmd("FormatEnable")
	else
		vim.cmd("FormatDisable")
	end
end, { desc = "Toggle Autoformat" })

vim.keymap.set({ "n", "v" }, "<leader>cn", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true }, function(err, did_edit)
		if not err and did_edit then
			vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
		end
	end)
end, { desc = "Format buffer" })

vim.keymap.set({ "n", "v" }, "<leader>cF", function()
	require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end, { desc = "Format Injected Langs" })
