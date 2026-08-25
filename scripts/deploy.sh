#!/usr/bin/bash
set -euo pipefail

git pull

/home/steve/.rbenv/versions/3.2.3/bin/ruby ./scripts/fetch_blogs.rb

git commit -am "Automated deploy"
git push

# Notify monitoring service
curl https://hc-ping.com/f23b4ebb-b035-44c5-b100-9d263c64194b 
