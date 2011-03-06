#!/usr/bin/env ruby

require 'date'
require "net/http"

today = Date.today

day   = today.day
day   = "0" + day.to_s if day < 10
month = today.month
month = "0" + month.to_s if month < 10
year  = today.year

File.open("channels.txt").each { |line|
  part = line.chomp.split
  channel = part[0]

  puts "Downloading channel #{channel}..."

  url = "http://www.canalsat-maurice.com/no_cache/guide-des-programmes/guide-des-programmes/programmes-jour-par-jour/?programme[jour]=#{day}%2F#{month}%2F#{year}&programme[horaires]=6.&programme[chaine]=#{channel}&programme[genre]=&Submit=OK&programme[pdf]="

  `wget -O #{channel}.html "#{url}"` 
}
