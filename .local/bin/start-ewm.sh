#!/usr/bin/env sh

# Esta variable busca el ejecutable de ewm
#EWM_COMP_DIR=$HOME/.repos/ewm
#EWM_MODULE_PATH=$EWM_COMP_DIR/compositor/target/debug/libewm_core.so \
#    emacs --fg-daemon -L $EWM_COMP_DIR/lisp -l ewm -f ewm-start-module

##################

EWM_COMP_DIR=$HOME/.repos/ewm
export EWM_MODULE_PATH="$EWM_COMP_DIR/compositor/target/debug/libewm_core.so"

exec uwsm start -- emacs --fg-daemon -L $EWM_COMP_DIR/lisp -l ewm -f ewm-start-module
