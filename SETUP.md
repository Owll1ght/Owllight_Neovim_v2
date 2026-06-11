What to install for everyday usage :

- git
- gcc
- Ripgrep
- fd
- clang (for cargo)
- cargo
- tree-sitter-cli (from cargo)
- Nerd Fonts
- .net sdk for c#
- Go
- Luarocks
- Rustfmt

In Fedora :
sudo dnf install git gcc fd ripgrep tree-sitter-cli dotnet-sdk-10.0 cargo clang go luarocks rustfmt
sudo cargo install tree-sitter-cli

Additional Download for minimizing warnings and errors in :checkhealth :

sudo dnf upgrade --refresh
sudo dnf install magick ruby gem java javac julia php composer python3-pip python3-wheel gs pdflatex sqlite3
sudo dnf copr enable dejan/lazygit
sudo dnf install lazygit

pip install mmdc
pip3 install --user --upgrade pynvim

For Windows :
winget install Neovim.Neovim
winget install --id Git.Git -e --source winget
winget install -e --id BurntSushi.ripgrep.MSVC
winget install sharkdp.fd
winget install -e --id LLVM.LLVM
winget install Rustlang.Rustup
winget install -e --id Microsoft.DotNet.SDK.10
winget install -e --id GoLang.Go
winget search buildtools

Download and install VisualStudioCode for MSVC, etc
cargo install tree-sitter-cli

To Install Scoop :
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
If encounter error in scoop installer :
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

scoop bucket add main
scoop install luarocks
scoop install ruby
scoop install nodejs

winget install julia -s msstore
winget install PHP.PHP.8.5

scoop install python
scoop install composer
scoop install miktex

winget install Citadel5-JP.GS-Base
winget install -e --id SQLite.SQLite
winget install -e --id JesseDuffield.lazygit
winget install ImageMagick.Q16-HDRI

pip install mmdc
