#!/usr/bin/env python

import subprocess

def download(site, prefix, maxoffset):
    for offset in range(0, maxoffset + 1, 5):
        if offset < 10:
            offset = "0" + str(offset)

        portion = ""
        if offset != "00":
            portion = "/(offset)/" + str(offset)

        subprocess.call("wget -O %s%s.html.gz --header=\"Accept-Encoding: gzip\" \"http://%s/grille-tv/toutes-les-chaines%s\"" % (prefix, offset, site, portion), shell=True)
        subprocess.call("gunzip -f %s%s.html.gz" % (prefix, offset), shell=True)

download("www.canalplus-maurice.com", "M", 65)
download("www.canalplus-reunion.com", "R", 70)
