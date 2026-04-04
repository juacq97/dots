#!/bin/bash

STATE_FILE="$HOME/.cache/global_lastdir"
LAST_DIR="$HOME"

# Leer el último directorio visitado por cualquier terminal
if [ -f "$STATE_FILE" ]; then
    LAST_DIR=$(head -n 1 "$STATE_FILE")
fi

# Validar que el directorio exista
if [ ! -d "$LAST_DIR" ]; then
    LAST_DIR="$HOME"
fi

# Reemplaza 'alacritty' por tu emulador de terminal
ghostty -e zsh -i -c "yy '$LAST_DIR'; exec zsh"
