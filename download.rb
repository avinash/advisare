#!/usr/bin/env ruby

def download(site, prefix, maxoffset)
  0.step(maxoffset,5) { |offset|
    offset  = "0" + offset.to_s if offset < 10
    
    portion = ""
    portion = "/(offset)/#{offset}" if offset != "00"

    `wget -O #{prefix}#{offset}.html.gz --header="Accept-Encoding: gzip" "http://#{site}/grille-tv/toutes-les-chaines#{portion}"`
    `gunzip -f #{prefix}#{offset}.html.gz`
  }
end

download("www.canalplus-maurice.com", "M", 65)
download("www.canalplus-reunion.com", "R", 70)
