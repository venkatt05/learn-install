#!/usr/bin/env zsh

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash &&

source ~/.zshrc &&

nvm install lts/hydrogen &&

nvm alias default lts/hydrogen &&

brew install yarn &&

brew install pkg-config cairo pango libpng jpeg giflib librsvg pixman &&

echo 'autoload -U add-zsh-hook
  load-nvmrc() {
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version
      nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
        nvm use
      fi
    elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version \ndefault)" ]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc' | tee -a $HOME/.zshrc &&

cd $HOME/work &&

git clone git@github.com:blackboard-learn/ultra.git &&

cd ultra &&

nvm use &&

./update.sh &&

cd $HOME &&

echo "run './work/bb/blackboard/tools/admin/UpdateUltraUIDecision.sh --on' after learn installation to enable Ultra"