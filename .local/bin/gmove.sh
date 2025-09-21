#! /bin/sh

get_region(){
  read x y w h <<< $(slop -l --bordersize=5 --color=0.992,0.965,0.89,0.7 -f "%x %y %w %h")
}

get_window_id(){
  gdbus call --session \
    --dest org.gnome.Shell \
    --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.List \
  | sed -E "s/^\('//; s/',\)$//" \
  | jq '.[] | select(.focus).id'
}

move_and_resize(){
  wid=$(get_window_id)

  gdbus call --session \
 --dest org.gnome.Shell \
 --object-path /org/gnome/Shell/Extensions/Windows \
 --method org.gnome.Shell.Extensions.Windows.MoveResize \
 $wid $x $y $w $h
  }

open_arc(){
  gdbus call --session \
  --dest org.gnome.Shell \
  --object-path /com/Extensions/ArcMenu \
  --method com.Extensions.ArcMenu.ToggleArcMenu
}

move_window(){
  get_region
  move_and_resize
}

open_app(){
  # open_arc
  flatpak run app.devsuite.Ptyxis --new-window &
  get_region
  move_and_resize
}

case $1 in
  "-m")
  move_window
  ;;
  "-o")
  open_app
  ;;
esac
