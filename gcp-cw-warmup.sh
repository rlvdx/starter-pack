#!/usr/bin/bash

# First upgrade
sudo apt update && sudo apt upgrade -y

# Base packages installation
sudo apt install -y \
  htop \
  fzf \
  zsh \
  bat \
  zoxide \
  direnv \
  git \
  bash \
  gitlab-cli \
  wget \
  curl \
  shellcheck \
  ripgrep \
  fd-find \
  xclip \
  rsync

# Linux brew and packages
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # press ENTER
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
sudo apt install -y build-essential

brew install gcc derailed/k9s/k9s
brew install jesseduffield/lazygit/lazygit

brew cleanup --quiet --prune=all

# Mise
curl https://mise.run | sh
eval "$(/home/user/.local/bin/mise activate bash)"

mise install terraform && mise use terraform

# Packages to install outside of apt
## yq
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && sudo chmod +x /usr/bin/yq

## Vault
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y libcap2-bin vault # because setcap command not found without libcap

## 1Password
# Install 1Password CLI
ARCH="amd64"; \
    OP_VERSION="v$(curl https://app-updates.agilebits.com/check/1/0/CLI2/en/2.0.0/N -s | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')"; \
    curl -sSfo op.zip \
    https://cache.agilebits.com/dist/1P/op2/pkg/"$OP_VERSION"/op_linux_"$ARCH"_"$OP_VERSION".zip \
    && sudo unzip -od /usr/local/bin/ op.zip \
    && rm op.zip

## Neovim
### To get v0.10 (apt gives us 0.9)
mise install neovim && mise use neovim

### LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
sudo apt install -y luarocks

## k8s
curl https://raw.githubusercontent.com/blendle/kns/master/bin/kns -o sudo /usr/local/bin/kns && sudo chmod +x $_
curl https://raw.githubusercontent.com/blendle/kns/master/bin/ktx -o sudo /usr/local/bin/ktx && sudo chmod +x $_
