#!/bin/sh

./download.rb

./parse.rb cinema > html/cinema.inc
./parse.rb decouverte > html/decouverte.inc
./parse.rb divertissement > html/divertissement.inc
./parse.rb jeunesse > html/jeunesse.inc
./parse.rb magazine > html/magazine.inc
./parse.rb musique > html/musique.inc
./parse.rb series > html/series.inc
./parse.rb sport > html/sport.inc
