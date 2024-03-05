# Installation Guide

Follow the steps below to set up your environment:

### Prerequisite :
Create your Github account with Anthology email ID & raise necessary access for all the projects.
( Mostly this step is applicable only for new employees. You can ignore this step, if you already got access to those projects. )

# Steps

### Step 1 :
Run the blow command in your terminal
```bash
chmod +x ~/learn-install/v2/pre.zsh
```

### Step 2 :
**Note:**
1. Run the below command by replacing the emailId with your anthology email and userName with your name.
2. When asked for password, enter you system password.
3. When SSH prompt asks for a passkey. Just press enter without providing any key.

```bash 
~/learn-install/v2/pre.zsh {emailId}
```

### Step 3 :
To add you ssh key to your github account, follow the below points -
1. run the command - "pbcopy < ~/.ssh/id_ed25519.pub".
2. Go to your github account > settings > SSH and GPG keys.
3. click on "New SSH Key".
4. Type a title for the ssh. ex: anthology-ssh.
5. press "command + v" to paste the SSH into the value box.
6. once the key is added, click on "configure sso" button and authorize all the projects.

### Step 4 :
**Note:**
1. Type Yes or Y whenever terminal prompts you with a question.

```bash
~/learn-install/v2/main.zsh
```

## General notes on uninstallation :
To uninstall postgres

```bash
sudo rm -rf /Library/PostgreSQL
```

How to fix the below errror :

> Not able to start postgres @12 using brew command "brew services start postgresql@12".
> "Error: Failure while executing; `/bin/launchctl bootstrap system /Library/LaunchDaemons/homebrew.mxcl.postgresql@12.> plist` exited with 5. "

```bash
sudo chown -R $(whoami) /usr/local/var/postgresql@12
brew services stop postgresql@12
brew services start postgresql@12
```
