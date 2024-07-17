# Installation Guide

Follow the steps below to set up your environment:

### Prerequisite :

Create your Github account with Anthology email ID & raise necessary access for all the projects.
( Mostly this step is applicable only for new employees. You can ignore this step, if you already got access to those projects. )

# Steps

### Step 1 :
1. signin https://github.com/ 
2. Run the below command in your terminal

```bash {"id":"01J08ZGVVGPEX3SFP2YEYH21CW"}
xcode-select --install
git clone https://github.com/venkatt05/learn-install.git
```

### Step 2 :

1. Run the below command.
2. When asked for password, enter you system password.
3. When SSH prompt asks for a passkey. Just press enter without providing any key.

```bash {"id":"01J08ZGVVGPEX3SFP2YH80NTT0"}
~/learn-install/pre.zsh
```

### Additional Instructions for any issues :

To uninstall postgres

```bash {"id":"01J08ZGVVGPEX3SFP2YPRSZV0T"}
sudo rm -rf /Library/PostgreSQL
```

How to fix the below errror :

> Not able to start postgres @12 using brew command "brew services start postgresql@12".
> "Error: Failure while executing; `/bin/launchctl bootstrap system /Library/LaunchDaemons/homebrew.mxcl.postgresql@12.> plist` exited with 5. "

```bash {"id":"01J08ZGVVGPEX3SFP2YPT91Q9Z"}
sudo chown -R $(whoami) /usr/local/var/postgresql@12
brew services stop postgresql@12
brew services start postgresql@12
```
