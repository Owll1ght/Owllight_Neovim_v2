-- *******************************************************************************
-- C# Debugger
-- *******************************************************************************

local dap = require("dap")

-- ====================================
-- Helper : Fix slashes for Windows
-- ====================================

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

-- ====================================
-- Helper : Find the root directory
-- ====================================

local function get_project_root()
	-- Start from the directory of the file you currently have open
	local current_file_dir = vim.fn.expand("%:p:h")
	-- Search upward (the ';' means search upward) for any .csproj file
	local csproj_file = vim.fn.findfile("*.csproj", current_file_dir .. ";")

	if csproj_file ~= "" then
		-- If found, return the folder containing the .csproj
		---@cast csproj_file string
		return vim.fn.fnamemodify(csproj_file, ":p:h")
	end
	return vim.fn.getcwd()
end

-- ====================================
-- .NET / C# Configuration (netcoredbg)
-- ====================================

local windows_debugger_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg"
local non_windows_debugger_path = vim.fn.exepath("netcoredbg")

if Is_windows then
	Debugger_path = windows_debugger_path .. ".exe"
elseif not Is_windows then
	Debugger_path = non_windows_debugger_path
end

dap.adapters.coreclr = {
	type = "executable",
	-- Ensure the executable path is normalized
	command = normalize_path(Debugger_path),
	args = { "--interpreter=vscode" },
	options = {
		detached = not Is_windows,
	},
}

dap.adapters.mono = {
	type = "executable",
	command = normalize_path(vim.fn.stdpath("config") .. "/mono-debug/extension/bin/Release/mono-debug.exe"),
}

dap.configurations.cs = {

	-- ********************************************************************************
	-- Standard C# / .NET Debugger
	-- ********************************************************************************

	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		console = "integratedConsole",
		stopAtEntry = true, -- Stops code stepping right at the start
		justMyCode = true, -- Solve the problem for opening the file using nvim . or telescope
		env = {
			ASPENTCORE_ENVIRONMENT = "Development",
		},
		cwd = function()
			-- Ensure the project root path is normalized
			return vim.fn.fnamemodify(get_project_root(), ":p")
		end,
		sourceFileMap = {
			[vim.fn.fnamemodify(get_project_root(), ":p")] = vim.fn.fnamemodify(get_project_root(), ":p"),
		},
		program = function()
			local project_root = vim.fn.fnamemodify(get_project_root(), ":p")

			-- Try to automatically find the dll in the bin/Debug folder
			local dll_paths = vim.fn.glob(project_root .. "bin/Debug/**/*.dll", true, true)

			local default_path = project_root .. "/bin/Debug/"
			if #dll_paths > 0 then
				-- Pre-fill with the first found dll to save time
				default_path = dll_paths[1]
			end

			if #dll_paths == 0 then
				vim.notify("No DLLs found in " .. project_root .. "bin/Debug/", vim.log.levels.ERROR)
				return ""
			end

			local target_path = vim.fn.input("Path to dll: ", default_path, "file")

			-- STRICT SAFETY CHECK: Prevent accidental folder submission
			if vim.fn.isdirectory(target_path) == 1 then
				vim.notify("ERROR: You provided a directory, not a .dll file! Debugger aborting.", vim.log.levels.ERROR)
				return ""
			end

			print("Project Root detected as: " .. get_project_root())
			-- Ensure the final .dll path is normalized
			return normalize_path(target_path)
		end,
	},

	-- ********************************************************************************
	-- Godot 3.6 C# Debugger - Attach
	-- ********************************************************************************

	{
		type = "mono",
		name = "Godot 3.6 - Attach to Mono",
		request = "attach",
		address = "127.0.0.1",
		port = 23685,
		justMyCode = true,
	},

	-- ********************************************************************************
	-- Godot 3.6 C# Debugger - Attach (Stop At Entry)
	-- ********************************************************************************

	{
		type = "mono",
		name = "Godot 3.6 - Attach to Mono (Stop at Entry)",
		stopAtEntry = true,
		justMyCode = true,
		request = "attach",
		address = "127.0.0.1",
		port = 23685,
	},
}

-- *******************************************************************************
-- C# Debugger Ends
-- *******************************************************************************
