#! /bin/sh

get_window_id() {
    winid=$(kdotool getactivewindow)
}
get_region()
{
    read x y w h o <<< $(slurp -f "%X %Y %w %h %o")
}

move_and_resize()
{
    get_region
    get_window_id

    echo "x: $x"
    echo "y: $y"
    echo "w: $w"
    echo "h: $h"
    echo "o: $o"
    echo "window id:" $winid

    kdotool windowsize $winid $w $h
    sleep 0.1s
    kdotool windowmove $winid $x $y

}


move_and_resize
