# Installation Guide

Follow the steps below to set up your environment:

### Prerequisite :

Create your Github account with Anthology email ID & raise necessary access for all the projects.
( Mostly this step is applicable only for new employees. You can ignore this step, if you already got access to those projects. )

# Steps -- Please follow the below 2 steps carefully inorder to avoid script failures . It will be hard to check the cause of the failure .

### Step 1 :
1. Change the default browser to your desired one by opening "system settings-->Desktop and Dock -->Default web browser". Then it is mandatory to signin https://github.com/ with your anthology mail Id.
2. Run the below command in your terminal

```bash {"id":"01J08ZGVVGPEX3SFP2YEYH21CW"}
xcode-select --install
git clone https://github.com/venkatt05/learn-install.git
```

### Step 2 :

1. Run the below command.
2. When asked for password, enter you system password.
3. For the first 5 mins be cautious on the terminal and follow the instructions given in the terminal .It will provide the ssh key You need to manually copy it in GitHub .

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
