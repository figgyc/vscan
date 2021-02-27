#!/bin/sh

#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

## development comments ##
# blank.png base layer
# document layer multiply
# 2px -spread filter
# black level is about #4b4b4b on solids
# #040203 on edges

# writing black is about #868686
# or #323232 edges
# edges r about 2px

# gimp levels: output 50/255


# blank.png base layer
# document layer multiply
# 2px -spread filter
# 0.2 degrees of rot
# gimp glow: 5r, 0.1 brightness, 1 sharpness

if [ "$#" -ne 2 ]; then
    echo "usage: $0 in.pdf out.pdf"
    exit 2
fi


pdftoppm -png -r 600 "$1" /tmp/vscan

for p in /tmp/vscan*; do
 #gimp -i -b "(simple-softglow \"$p\" )" -b "(gimp-quit 0)"
 magick convert blank.png \( "$p" -spread 1 -rotate 0.2 -geometry 4960x7016 \) -compose Multiply -composite \
 -sampling-factor 4:2:0 -strip -quality 40 -colorspace RGB "$p.jp2"
done

img2pdf /tmp/vscan*.jp2 -s 600dpi -o "$2"
# pdfsizeopt "$2" "$2"

rm /tmp/vscan*
