#!/usr/bin/env ruby

package_mosaiqueplus = ["1", "4", "6", "7", "11", "12", "13", "15", "20", "25", "26", "29", "32", "33", "41", "45", "51", "55", "61", "63", "68", "85", "99", "100", "101"]
package = package_mosaiqueplus
channelsdone = []

types = ["cinema", "decouverte", "divertissement", "jeunesse", "magazine", "musique", "series", "sport"]

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

0.step(60,5) { |offset|
  offset  = "0" + offset.to_s if offset < 10
  file = "M#{offset}.html"
  
  doc = Nokogiri::HTML(File.open(file), nil, "utf-8")
  doc.css("div#listChaineGrilleTV").each { |allchannels|
    allchannels.css("div.flt-l").each { |channel|
      channelnumber = (channel.css("div.numero_canal").text.split)[1]
      channelname   = channel.css("h2.channel-label").text

      if (not channelsdone.include? channelnumber) and (package.include? channelnumber)
        channelsdone.push channelnumber
      else
        next
      end
      
      channel.css("li.#{type}").each { |programme|
        time = programme.css("span.inl").text
        title = programme.css("strong").text
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
        
        puts "#{rating}\t#{channelnumber}\t#{time}\t#{url}\t#{channelname}\t#{title}"
        $stdout.flush
      }
    }
  }
}

0.step(70,5) { |offset|
  offset  = "0" + offset.to_s if offset < 10
  file = "R#{offset}.html"
  
  doc = Nokogiri::HTML(File.open(file), nil, "utf-8")
  doc.css("div#listChaineGrilleTV").each { |allchannels|
    allchannels.css("div.flt-l").each { |channel|
      channelnumber = (channel.css("div.numero_canal").text.split)[1]
      channelname   = channel.css("h2.channel-label").text

      if (not channelsdone.include? channelnumber) and (package.include? channelnumber)
        channelsdone.push channelnumber
      else
        next
      end
      
      channel.css("li.#{type}").each { |programme|
        time = programme.css("span.inl").text
        title = programme.css("strong").text
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
        
        puts "#{rating}\t#{channelnumber}\t#{time}\t#{url}\t#{channelname}\t#{title}"
        $stdout.flush
      }
    }
  }
}
