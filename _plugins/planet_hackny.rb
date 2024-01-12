require "rss"
require "yaml"

# Named after the planet.hackny.org of yesteryear
module PlanetHackNY
  class PlanetGenerator < Jekyll::Generator
    def fetch_feed(fellow)
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

    def generate(site)
      all_posts = []

      site.data["fellows"].each_with_index do |fellow, i|
        next unless fellow.include?("rss_url")
        begin
          all_posts += fetch_feed(fellow)
        rescue
          puts("[RSS]: Error fetching RSS for #{fellow["name"]}.")
        end
      end

      site.data["planet"] = all_posts.sort do |a, b|
        a[:published_at] <=> b[:published_at]
      end
    end
  end
end
