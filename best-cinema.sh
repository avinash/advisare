#!/bin/sh

cat cinema.txt | egrep -v '^N/A|Retrying' | sort -nr | less
