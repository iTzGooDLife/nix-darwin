{ pkgs }:

with pkgs; [
  # General packages for development and system management

  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  killall
  neofetch
  openssh
  sqlite
  wget
  zip
  opencommit
  neovim
  snyk
  ghidra-bin
  sqlitebrowser
  scrcpy
  sqlmap
  apktool
  openjdk
  libpcap
  flameshot
  wireguard-tools
  _7zz
  neovide
  obsidian
  pam-reattach
  gh

  # deps
  mono

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf
  nerd-fonts.jetbrains-mono

  # Node.js development tools
  # nodePackages.npm # globally install npm
  # nodePackages.prettier
  # nodejs

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jetbrains-mono
  jq
  ripgrep
  tree
  tmux
  unrar
  unzip
  zsh-powerlevel10k

  # Python packages
  python3
  python313Packages.pip
  virtualenv

  # Languages
  nodejs_20
  ## PHP ##
  php83
  php83Packages.composer
  ## PHP ##
  ruby
  go
]
