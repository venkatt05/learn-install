#!/usr/bin/env zsh

userEmail="$1"

cd $HOME/work &&

caffeinate git clone git@github.com:blackboard-learn/learn.git &&

git clone git@github.com:blackboard-learn/learn.util.git &&

cd learn.util &&

sudo cp -R users/template users/$USER &&

cd $HOME &&

sudo sed -i '' "s/<your username>/$USER/g" $HOME/work/learn.util/users/$USER/gradle/gradle.git.properties &&

sudo sed -i '' "s/<your username>/$USER/g" $HOME/work/learn.util/users/$USER/learnConfigs/spgit.properties &&

sudo sed -i '' "s/<your email address>/$userEmail/g" $HOME/work/learn.util/users/$USER/gradle/gradle.git.properties &&

sudo sed -i '' "s/<your email address>/$userEmail/g" $HOME/work/learn.util/users/$USER/learnConfigs/spgit.properties &&

mkdir -p $HOME/work/bb/blackboard-data &&

source ~/.zshrc &&

cd $HOME/work/learn.util &&

source sourceall.sh &&

echo '\nexport GIT_ROOT=$HOME/work/learn \nexport PATH=$PATH:$GIT_ROOT/bin \nsource $HOME/work/learn.util/sourceall.sh \nsource $HOME/scripts/current_sp.sh' >> $HOME/.zshrc &&

source $HOME/.zshrc

mkdir -p $HOME/.gradle &&

touch $HOME/.gradle/gradle.properties &&

cd ~/work/learn.util &&

mkdir -p $WORK_HOME/scripts/logs &&

sp git &&

source $HOME/.zshrc &&

echo '\nexport BLACKBOARD_HOME=$HOME/work/blackboard
\nexport bbHome=$HOME/work/blackboard
\nexport LEARN_UTIL_HOME=$HOME/work/learn.util/users/$USER
\nexport YARN_CACHE_FOLDER=$HOME/work/caches/yarn
\nexport PGHOST=localhost
\nexport LEARN_URL="https://mylearn.int.bbpd.io"
\nexport LEARN_USERNAME="administrator"
\nexport LEARN_PASSWORD="changeme"' >> $HOME/.zshrc &&

source $HOME/.zshrc &&

cd ~/work/learn &&

echo "Turn off zscalar and run 'gdl clean && gdl installLearn'" 