#!/usr/bin/env sh

geometry=$(slurp)

w=$(echo "$geometry" | cut -d" " -f2 | cut -d'x' -f1)
h=$(echo "$geometry" | cut -d" " -f2 | cut -d'x' -f2)
x=$(echo "$geometry" | cut -d, -f1)
y=$(echo "$geometry" | cut -d, -f2 | cut -d " " -f1)

echo "x: $x"
echo "y: $y"
echo "w: $w"
echo "h: $h"

id=$(kdotool getactivewindow)

kdotool set_desktop_for_window $id "current_desktop"
kdotool windowmove $id $x $y
kdotool windowsize $id $w $h
kdotool windowactivate $id
