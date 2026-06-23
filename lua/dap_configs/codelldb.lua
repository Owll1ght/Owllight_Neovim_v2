local dap = require("dap")

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
		name = "Server Launch File (External Terminal)",
		type = "codelldbserv",
		request = "launch",
		program = function()
			return program_input()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		terminal = "external",
	},
	{
		name = "Executable Launch File (External Terminal)",
		type = "codelldb",
		request = "launch",
		program = function()
			return program_input()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		terminal = "external",
	},
	{
		name = "Server Launch File (Console Terminal)",
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
		name = "Executable Launch File (Console Terminal)",
		type = "codelldb",
		request = "launch",
		program = function()
			return program_input()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		terminal = "console",
	},
}

if not Is_windows then
	table.insert(dap.configurations.c, {
		name = "Server Launch File (Integrated Terminal)",
		type = "codelldbserv",
		request = "launch",
		program = function()
			return program_input()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		terminal = "integrated",
	})
	table.insert(dap.configurations.c, {
		name = "Executable Launch File (Integrated Terminal)",
		type = "codelldb",
		request = "launch",
		program = function()
			return program_input()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		terminal = "integrated",
	})
end

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c
dap.configurations.zig = dap.configurations.c
dap.configurations.odin = dap.configurations.c
