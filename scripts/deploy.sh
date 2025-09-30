#!/usr/bin/bash

git pull

# I know this is jank to hard code but it's only running on my server for now
# and I don't have time to do this the right way right this second. pls forgive
# me, for I have sinned.
/home/steve/.rbenv/versions/3.2.3/bin/ruby ./scripts/fetch_blogs.rb
cat ~/Code/webring/_data/fellows.yaml | yq '.[].rss_url' | sed -e '/^null$/d' > ~/.cache/zulip-rss/rss-feeds

git commit -am "Automated deploy"
git push

# Trigger Zulip blog watcher
/home/steve/Code/python-zulip-api/.direnv/python-3.13/bin/python \
	/home/steve/Code/python-zulip-api/zulip/integrations/rss/rss-bot \
	--stream=blog-posts

# Notify monitoring service
curl https://hc-ping.com/f23b4ebb-b035-44c5-b100-9d263c64194b 
