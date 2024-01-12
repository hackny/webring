#!/usr/bin/env ruby
require "rss"
require "yaml"

def fetch_posts(fellow)
  posts = []
  URI.open(fellow["rss_url"]) do |rss|
    feed = RSS::Parser.parse(rss)
    posts = feed.items.map do |item|
      {"id" => item.guid.content,
       "title" => item.title,
       "url" => item.link,
       "fellow" => fellow,
       "description" => item.description,
       "published_at" => item.pubDate}
    end
  end

  puts("[RSS]: Fetched #{posts.size} items for #{fellow["name"]}")
  return posts
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
