#!/usr/bin/bash
set -euo pipefail

git pull

/home/steve/.rbenv/versions/3.2.3/bin/ruby ./scripts/fetch_blogs.rb

if ! git diff --quiet; then
    git commit -am "Automated deploy"
    git push
fi

# Notify monitoring service
curl -fsS --retry 3 https://hc-ping.com/f23b4ebb-b035-44c5-b100-9d263c64194b
