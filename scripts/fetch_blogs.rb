#!/usr/bin/env ruby
require "rss"
require "yaml"

def fetch_posts(fellow)
  posts = []
  URI.open(fellow["rss_url"]) do |rss|
    feed = RSS::Parser.parse(rss)
    posts = feed.items.map do |item|
      if item.class == RSS::Atom::Feed::Entry
        id = item.id.content.to_s
        title = item.title.content.to_s
        content = item.content.to_s
        published_at = DateTime.parse(item.published.content.to_s)
        link = item.link.href.to_s
      else
        id = item.guid.content
        title = item.title
        content = item.description
        published_at = item.pubDate
        link = item.link
      end

      {"id" => id,
       "title" => title,
       "url" => link,
       "fellow" => fellow.clone,
       "published_at" => published_at.strftime('%Y-%m-%d %H:%M')}
    end
  end

  puts("[RSS]: Fetched #{posts.size} items for #{fellow["name"]}")

  # Only get the first 10 posts, we don't need to store everything
  return posts[0..10]
end

fellows = YAML.load(File.read("_data/fellows.yaml"))
all_posts = []
fellows.each_with_index do |fellow, i|
  next unless fellow.include?("rss_url")
  begin
    all_posts += fetch_posts(fellow)
  rescue Exception => err
    puts("[RSS]: Error fetching RSS for #{fellow["name"]}: #{err}")
  end
end

planet = all_posts.sort do |a, b|
  a[:published_at] <=> b[:published_at]
end

File.open("_data/planet.yaml", "w") do |f|
  f.write(YAML.dump(planet))
end
