#!/usr/bin/env zsh
echo "Enter your userEmail: "
read userEmail

echo "Enter your userName: "
read userName

echo "Enter your password: "
read -s password

# Source the zshrc file
source ~/.zshrc

# Install or upgrade Git and Git LFS
echo -e "\e[33mInstalling or upgrading Git and Git LFS\e[0m"
brew install git || brew upgrade git &&
brew install git-lfs || brew upgrade git-lfs &&

# Install Git LFS
echo -e "\e[33mInstalling Git LFS\e[0m"
git lfs install &&

# Configure Git
echo -e "\e[33mConfiguring Git\e[0m"
git config --global merge.renamelimit 999999 &&
git config --global diff.renamelimit 999999 &&
git config --global "lfs.https://stash.bbpd.io/learn/learn.git/info/lfs.locksverify" false &&
git config --global "lfs.contenttype" false &&

# Configure Git user
echo -e "\e[33mConfiguring Git user\e[0m"
# read "?Enter your fullname (FirstName LastName) : " firstName &&
git config --global user.name "$userName"
git config --global user.email "$userEmail"

# Configure system settings
echo -e "\e[33mConfiguring system settings\e[0m"
echo "$password" | sudo -S sh -c 'echo "kern.maxfiles=65536
kern.maxfilesperproc=65536" > /etc/sysctl.conf' &&

# Configure LaunchDaemons
echo -e "\e[33mConfiguring LaunchDaemons\e[0m"
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
     <string>limit.maxfiles</string>
      <key>ProgramArguments</key>
      <array>
        <string>launchctl</string>
        <string>limit</string>
        <string>maxfiles</string>
        <string>65536</string>
        <string>65536</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>ServiceIPC</key>
      <false/>
  </dict>
</plist>' | sudo tee /Library/LaunchDaemons/limit.maxfiles.plist &&

echo '<!DOCTYPE plist PUBLIC "-//Apple/DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
      <string>limit.maxproc</string>
    <key>ProgramArguments</key>
      <array>
        <string>launchctl</string>
        <string>limit</string>
        <string>maxproc</string>
        <string>2048</string>
        <string>2048</string>
      </array>
    <key>RunAtLoad</key>
      <true />
    <key>ServiceIPC</key>
      <false />
  </dict>
</plist>' | sudo tee /Library/LaunchDaemons/limit.maxproc.plist &&

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
  echo -e "\e[1;31mAdd the above Public SSH to your github account and configure it.
  you can see there is a URL opened in your default browser. Add the SSH key to your github account and then once the key is added, click on "configure sso" button and authorize all the projects..
  For more details Refer : https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account. Proceed with next steps once done.\e[0m""
  pbcopy < ~/.ssh/id_ed25519.pub
  open "https://github.com/settings/ssh/new"
 else
  echo "SSH key already present. Add to your github account(https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and then configure the SSH. Once done proceed with next steps."

fi
