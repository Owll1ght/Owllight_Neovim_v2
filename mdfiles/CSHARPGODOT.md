======================================================
CONFIGURATION FOR GODOT 3.6 C# MONO DEBUGGER
======================================================

For Godot 3.6 mono debugger configuration, do these from the Godot app :
1. In the top menu bar of the Godot Editor, click Project > Project Settings...
2. Make sure you are on the General tab.
3. Scroll all the way down the left-hand panel until you see the Mono category.
4. Expand Mono and click on Debugger Agent.

And then inside the menu, find these toggles and menus :
1. Wait for Debugger: Check this ON.
2. Wait Timeout: Change this from the default (3000) to 10000 (10 seconds) to give more time to start the debugger from Neovim.
3. Port: Ensure this is set to 23685 (Which exactly match with the configuration inside of the dap.lua file).

To start the debugging, First build the project from inside of Godot. After that, open the file in neovim, and give breakpoints for the code to stop. Start the project using the start button inside of Godot, where a freezing window is going to show up. When the window shows up, go to the C# file that will be debugged, and then starts the debugging from neovim.

======================================================
CONFIGURATION FOR GODOT TO OPEN CODE FILES IN NEOVIM
======================================================

godot remote setting: --server {project}/server.pipe --remote-send "<C-\><C-N>:e {file}<CR>:call curosr({line}+1,{col})<CR>"

This is for windows godot remote setting, with path going to nvim.exe and nvim --listen 127.0.0.1:55432 in cmd or opens nvim in a directory with project.godot inside it : 
--server 127.0.0.1:55432 --remote-send "<C-\><C-N>:e {file}<CR>:call cursor({line},{col})<CR>"

In windows to open nvim from no cmd open :
Exec path to cmd.exe (/Windows/System32/cmd.exe)
Exec Flags :
/c start nvim --listen 127.0.0.1:5543 --server 127.0.0.1:5543 --remote-tab "{file}"
The port should NOT be the same with the one below here (inside of godot.lua)
