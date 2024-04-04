#!/usr/bin/env zsh

chmod +x ~/learn-install/v2/main.zsh
chmod +x ~/learn-install/v2/clone.zsh

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

  echo -e "\e[33mYour public SSH key Highlighted in Green Colour and is already copied:\e[0m" &&
  echo -e "\e[32m$(cat ~/.ssh/id_ed25519.pub)\e[0m"
  echo "\n"
  echo -e "\e[33m*******************  Read the Below Notes Carefully*********************\e[0m
    Add the above Public SSH to your GitHub account and configure it.
    You can see there is a GiHub URL opened in your default browser. Add the SSH key to your GitHub account and then once the key is added, click on \e[1;32mconfigure sso\e[0m button and authorize all the projects.
    \n
    For more details Refer: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account. Proceed with the next steps once done."

  pbcopy < ~/.ssh/id_ed25519.pub
  open "https://github.com/settings/ssh/new"

else
  echo "SSH key already present. Add to your github account(https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and then configure the SSH. Once done proceed with next steps."
fi
