#!/bin/bash

# Define tus perfiles
perfil_claro="Light"
perfil_oscuro="Dark"

helix_claro="catppuccin_latte"
helix_oscuro="catppuccin_macchiato"

helix_config="$HOME/.config/helix/config.toml"

cambiarColor() {
  local nuevo_perfil="$1"
  local nuevo_helix="$2"
  for app in $(qdbus6 | grep konsole); do
    for win_id in $(qdbus6 "$app" | grep '/Sessions'); do
      echo "→ $app $win_id"
      qdbus6 "$app" "$win_id" setProfile "$nuevo_perfil"
    done
  done

  kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile "$nuevo_perfil.profile"

  # Cambiando el color de helix tambien UwU

    sed -i "s/^theme = .*/theme = \"$nuevo_helix\"/" "$helix_config"
    pkill -USR1 helix
}

case "$1" in
-l)
  cambiarColor "$perfil_claro" "$helix_claro"
  ;;
-d)
  cambiarColor "$perfil_oscuro" "$helix_oscuro"
  ;;

*)
  echo default
  ;;
esac

# Detecta tema de Plasma (muy básico, puedes mejorarlo)
#plasma_es_oscuro=$(grep -i 'ColorScheme=' ~/.config/kdeglobals | grep -iq 'BreezeDark' && echo 1 || echo 0)

# Elige perfil según tema
#if [[ $plasma_es_oscuro -eq 1 ]]; then
#  nuevo_perfil="$perfil_oscuro"
#else
#  nuevo_perfil="$perfil_claro"
#fi

#echo "Aplicando perfil: $nuevo_perfil"
