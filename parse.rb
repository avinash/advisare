#!/usr/bin/env ruby

types = ["cinema", "decouverte", "divers", "divertissement", "generique", "infos_magazine_emission", "jeunesse", "musique", "serie_feuilleton", "sport"]

if (ARGV.length != 1) or (not types.include? ARGV[0]) then
  puts "Usage: parse.rb type"
  puts "where type is one of #{types}"
  puts "IMDB will be queried when type is cinema"
  exit
else
  type = ARGV[0]
  require 'nokogiri'
  require 'myimdb' if type == "cinema"
end

if type == "cinema" then
  class Myimdb::Scraper::Imdb
    def url
      @url
    end
  end
end

File.open('channels.txt').each { |line|
  channel, package, channelname = line.chomp.split
  file = "#{channel}.html"
  
  doc = Nokogiri::HTML(File.open(file), nil, "iso-8859-1")
  doc.css("div.#{type}").each { |programme|
    time, title = programme.css("a").text.delete("\n").squeeze(" \t").strip.split("\t")
    time = "0" + time if time.length == 4
    title.slice!(0)
    rating = "N/A"
    url = ""

    begin
      if type == "cinema" then
        movie = ImdbMovie.search(title + " intitle:imdb")
        rating = movie.rating
        rating = "N/A" if rating == 0.0
        url = movie.url if rating != "N/A"
      end
    rescue Exception
    end

    puts "#{rating}\t#{channel}\t#{time}\t#{url}\t#{channelname}\t#{title}"
    $stdout.flush
  }
}
