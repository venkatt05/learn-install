Download the files, Run the below commands one by one

Step 1
run  "chmod +x ~/learn-install/s1.zsh"


Step 2
run  "~/learn-install/s1.zsh"


Step 4
Create your Github account with Anthology email ID & raise necessary access for all the projects.
( Mostly this step is applicable only for new employees. You can ignore this step, if you already got access to those projects. )



Step 5

Note:
	1. Run the below command by replacing the emailID with your anthology email and userName with your name.
	2. While running the below command, When SSH prompt asks for a passkey. Just press enter without providing any key.

run "~/learn-install/s4.zsh emailID userName"



Step 6
To add you ssh key to your github account, follow the below points
 1. run the command - "pbcopy < ~/.ssh/id_ed25519.pub"
 2. Go to your github account > settings > SSH and GPG keys
 3. click on "New SSH Key"
 4. Type a title for the ssh. ex: anthology-ssh
 5. press "command + v" to paste the SSH into the value box.
 6. once the key is added, click on "configure sso" button and authorize all the projects.



Step 7

Note:
	1. Type Yes or Y whenever terminal prompts you with a question
	2. replace the emailID with your anthology email ID

run "~/learn-install/s5.zsh emailID"



Step 8 (Setting up scalar certs)
1. run  "cp -R ~/learn-install/zscaler-certs ~/work/zscaler-certs"
2. run "sudo keytool -import -trustcacerts -alias zscaler_root_ca -file ~/work/zscaler-certs/ZscalerRootCA.cer -cacerts"
3. when terminal asks for key password enter "changeit" and then enter
4. run "export NODE_EXTRA_CA_CERTS=~/work/zscaler-certs/ZscalerRootCA.pem"


Step 9
install docker desktop from - https://www.docker.com/products/docker-desktop/
