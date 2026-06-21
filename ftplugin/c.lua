local dap = require("dap")
local map = vim.keymap.set

local function normalize_path(path)
	if Is_windows then
		local fixed_path = path:gsub("/", "\\")
		if fixed_path:match("^[a-z]:") then
			fixed_path = fixed_path:gsub("^([a-z]):", string.upper)
		end
		return fixed_path
	end
	return path
end

-- local windows_debugger_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
-- local non_windows_debugger_path = vim.fn.exepath("codelldb")

local mason_registry = require("mason-registry")
local codelldb_pkg = mason_registry.get_package("codelldb")
local windows_debugger_path = codelldb_pkg:get_install_path() .. "/extension/adapter/codelldb"
local non_windows_debugger_path = vim.fn.exepath("codelldb")

if Is_windows then
	Debugger_path = windows_debugger_path .. ".exe"
elseif not Is_windows then
	Debugger_path = non_windows_debugger_path
end

dap.adapters.codelldb = {
	type = "executable",
	command = normalize_path(Debugger_path),
	detached = not Is_windows,
}

dap.adapters.codelldbserv = {
	type = "server",
	port = "${port}",
	executable = {
		command = normalize_path(Debugger_path),
		args = { "--port", "${port}" },
		detached = not Is_windows,
	},
}

local function program_input()
	local output_name = Is_windows and "/debug.exe" or "/debug"
	local file = vim.fn.expand("%:p:h") .. output_name
	if vim.fn.filereadable(file) == 0 then
		if Is_windows then
			file = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "\\", "file")
		elseif not Is_windows then
			file = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end
	end
	return normalize_path(file)
end

dap.configurations.c = {
	{
		name = "Launch File {Server Style}",
		type = "codelldbserv",
		request = "launch",
		program = function()
			return program_input()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		terminal = "console",
	},
	{
		name = "Launch File {Server Style} (stopOnEntry)",
		type = "codelldbserv",
		request = "launch",
		program = function()
			return program_input()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = true,
		terminal = "console",
	},
	{
		name = "Launch File",
		type = "codelldb",
		request = "launch",
		program = function()
			return program_input()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		terminal = "console",
	},
	{
		name = "Launch File (Stop at Entry)",
		type = "codelldb",
		request = "launch",
		program = function()
			return program_input()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = true,
		terminal = "console",
	},
}

map("n", "<leader>jd", "<cmd>:w | split | :term gcc % -g -o debug<CR>", { desc = "Use GCC Debug Output" })
