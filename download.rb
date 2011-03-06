#!/usr/bin/env ruby

0.step(60,5) { |offset|
  offset  = "0" + offset.to_s if offset < 10
  
  portion = ""
  portion = "/(offset)/#{offset}" if offset != "00"

  `wget -O M#{offset}.html "http://www.canalplus-maurice.com/grille-tv/toutes-les-chaines#{portion}"`
}

0.step(70,5) { |offset|
  offset  = "0" + offset.to_s if offset < 10
  
  portion = ""
  portion = "/(offset)/#{offset}" if offset != "00"

  `wget -O R#{offset}.html "http://www.canalplus-reunion.com/grille-tv/toutes-les-chaines#{portion}"`
}
