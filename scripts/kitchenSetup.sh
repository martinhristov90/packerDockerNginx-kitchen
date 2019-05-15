#!/bin/bash

sudo apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev ruby-dev

pushd ~/buildDir
sudo gem install bundler 
sudo bundler install
popd