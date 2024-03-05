#!/usr/bin/env zsh

chmod +x ~/learn-install/v2/main.zsh

userEmail="$1"

# This script is used to check and generate SSH key for the user. This is a pre-requisite script that should be ran before running the main script.
# Check if SSH key is present
echo -e "\e[33mChecking SSH key\e[0m"
if [  ! -f ~/.ssh/id_ed25519 ]; then

  ssh-keygen -t ed25519 -C "$userEmail" -N "" -f ~/.ssh/id_ed25519

  # Start SSH agent
  eval "$(ssh-agent -s)" &&

  # Configure SSH
  touch $HOME/.ssh/config &&
  echo -e 'Host github.com
  \nAddKeysToAgent yes
  \nUseKeychain yes
  \nIdentityFile ~/.ssh/id_ed25519' >> $HOME/.ssh/config &&

  # Add SSH key to agent
  ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519 &&

  echo -e "\e[33mYour public SSH key Highlighted in Green Colour:\e[0m" &&
  echo -e "\e[32m$(cat ~/.ssh/id_ed25519.pub)\e[0m"
  echo -e "\e[33mAdd the above Public SSH to your github account and configure it. Refer : https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account. Proceed with next steps once done.\e[0m"
 else
  echo "SSH key already present. Add to your github account(https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and then configure the SSH. Once done proceed with next steps."
