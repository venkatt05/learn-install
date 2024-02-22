#!/usr/bin/env zsh

userEmail="$1"

userName="$2"

source ~/.zshrc

brew install git || brew upgrade git &&

brew install git-lfs || brew upgrade git-lfs &&

git lfs install &&

git config --global merge.renamelimit 999999 &&

git config --global diff.renamelimit 999999 &&

git config --global "lfs.https://stash.bbpd.io/learn/learn.git/info/lfs.locksverify" false &&

git config --global "lfs.contenttype" false &&

# read "?Enter your fullname (FirstName LastName) : " firstName &&

git config --global user.name "$userName"

git config --global user.email "$userEmail"

echo "kern.maxfiles=65536
kern.maxfilesperproc=65536" | sudo tee /etc/sysctl.conf &&

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

if [ $(ls -al $HOME/.ssh) > 0 ]
then
  echo "SSH key already present. Add to your github account(https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and then configure the SSH. Once done proceed with next steps."
else
  ssh-keygen -t ed25519 -C "$userEmail" &&

  eval "$(ssh-agent -s)" &&

  touch $HOME/.ssh/config &&

  echo 'Host github.com
  \nAddKeysToAgent yes
  \nUseKeychain yes
  \nIdentityFile ~/.ssh/id_ed25519' >> $HOME/.ssh/config &&

  ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519 &&

  echo "Your public SSH key : $(cat id_ed25519.pub)" &&

  echo "Add the above Public SSH to your github account and configure it. Refer : https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account. Proceed with next steps once done."
fi