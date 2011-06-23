#!/usr/bin/env ruby

types = ["cinema", "decouverte", "divertissement", "jeunesse", "magazine", "musique", "series", "sport"]

if (ARGV.length != 1) or (not types.include? ARGV[0]) then
  puts "Usage: parse.rb type"
  puts "where type is one of #{types}"
  puts "IMDB will be queried when type is cinema"
  exit
else
  require "uri"
  require "nokogiri"
  require "open-uri"
  require "rexml/document"
  type = ARGV[0]
end

class Movie
  def initialize(title)
    @title = title
    @movie = nil
  end
  
  def query_imdb
    title_escaped = URI.escape(@title)
    response = open("http://www.imdbapi.com/?t=#{title_escaped}&r=XML")
    doc = REXML::Document.new(response)
    @movie = doc.root.elements["movie"] if doc.root != nil
  end
  
  def rating
    rating = "0.0"
    rating = @movie.attributes["rating"].to_f if @movie != nil
    return rating
  end
  
  def url
    url = ""
    url = "http://www.imdb.com/title/" + @movie.attributes["id"] + "/" if @movie != nil
    return url
  end
end

class Parser

  def initialize
    package_mosaiqueplus =
    ["1", "4", "6", "7", "11", "12", "13",
    "15", "20", "25", "26", "29", "32", "33",
    "41", "45", "51", "55", "61", "63", "68",
    "85", "99", "100", "101"]
    @package = package_mosaiqueplus
    @channelsdone = []
  end

  def parse_all_files(prefix, maximum, type)
    0.step(maximum,5) { |offset|
      parse_one_file(prefix, offset, type)
    }
  end
  
  def parse_one_file(prefix, offset, type)
    # What file needs to be parsed
    offset  = "0" + offset.to_s if offset < 10
    file = "#{prefix}#{offset}.html"

    # Open the file and get 
    doc = Nokogiri::HTML(File.open(file), nil, "utf-8")
    doc.css("div#listChaineGrilleTV").each { |allchannels|
      allchannels.css("div.flt-l").each { |channel|
        channelnumber = (channel.css("div.numero_canal").text.split)[1]
        channelname   = channel.css("h2.channel-label").text

        if (not @channelsdone.include? channelnumber) and (@package.include? channelnumber)
          @channelsdone.push channelnumber
        else
          next
        end
        
        channel.css("li.#{type}").each { |programme|
        time = programme.css("span.inl").text
        title = programme.css("strong").text

        rating = "N/A"
        url = "N/A"

        if type == "cinema" then
          movie = Movie.new(title)
          movie.query_imdb
          rating = movie.rating
          url = movie.url
        end

        puts "<tr>"
        puts "  <td>#{channelnumber}</td>"
        puts "  <td>#{channelname}</td>"
        puts "  <td>#{time}</td>"
        if url != "" then
          puts "  <td><a target=\"_blank\" href=\"#{url}\">#{title}</a></td>"
        else
          puts "  <td>#{title}</td>"
        end
        puts "  <td>#{rating}</td>"
        puts "</tr>"

        $stdout.flush
      }
    }
  }
  end
end

parser = Parser.new
parser.parse_all_files("M", 60, type)
parser.parse_all_files("R", 70, type)
