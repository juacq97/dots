#! /bin/sh

prepare_window_coord()
{
    # This function will move the window to the top left of the screen, now is on coordinate (0,0)
    riverctl snap left
    sleep 0.01
    riverctl snap up
}

prepare_window_size()
{
    #This function will change the window size to 0x0, this is done by changing the size to a stupid small size, I don't think there's any monitor with more than 10,000 pixels wide or tall. If so, I will change it to another ridiculous size.
    riverctl resize horizontal -10000
    sleep 0.01 # it needs to wait a bit 
    riverctl resize vertical -10000
}

get_region()
{
    read x y w h o <<< $(slurp -f "%x %y %w %h %o")
}

move_and_resize()
{
    prepare_window_size
    prepare_window_coord
    get_region

    echo "x: $x"
    echo "y: $y"
    echo "w: $w"
    echo "h: $h"
    echo "o: $o"

    riverctl move down $y && sleep 0.01 &&  riverctl move right $x
    sleep 0.01
    riverctl resize horizontal $w && sleep 0.01 &&  riverctl resize vertical $h

}


move_and_resize
