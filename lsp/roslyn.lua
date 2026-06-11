local command = {
	"roslyn",
	"--stdio",
	"--loglevel=Information",
}

return {
	cmd = command,
	root_markers = { { ".sln", ".csproj", "project.json" }, ".git", "project.godot" },
}
