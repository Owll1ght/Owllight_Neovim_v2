-- godot remote setting: --server {project}/server.pipe --remote-send "<C-\><C-N>:e {file}<CR>:call curosr({line}+1,{col})<CR>"
--
-- This is for windows godot remote setting, with path going to nvim.exe and
-- nvim --listen 127.0.0.1:55432 in cmd or opens nvim in a directory with project.godot inside it
-- --server 127.0.0.1:55432 --remote-send "<C-\><C-N>:e {file}<CR>:call cursor({line},{col})<CR>"
--
-- In windows to open nvim from no cmd open :
-- Exec path to cmd.exe (/Windows/System32/cmd.exe)
-- Exec Flags :
-- /c start nvim --listen 127.0.0.1:5543 --server 127.0.0.1:5543 --remote-tab "{file}"
-- The port should not be the same with the one below here

-- path to check for project.godot file
local paths_to_check = { "/", "/..", "" }
local is_godot_project = false
local godot_project_path = ""
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for _, value in pairs(paths_to_check) do
	if vim.uv.fs_stat(cwd .. value .. "project.godot") then
		is_godot_project = true
		godot_project_path = cwd .. value
		break
	end
end

-- check if server is already running in godot project path
local is_server_running = vim.uv.fs_stat(godot_project_path .. "/server.pipe")
-- start server, if not already running
if is_godot_project and not Is_windows and not is_server_running then
	vim.fn.serverstart(godot_project_path .. "/server.pipe")
	is_godot_project = true
elseif is_godot_project and Is_windows and not is_server_running then
	vim.fn.serverstart("127.0.0.1:55432")
	is_godot_project = true
end
