#!/usr/bin/bash

git pull
./scripts/fetch_blogs.rb
git commit -am "Automated deploy"
git push
