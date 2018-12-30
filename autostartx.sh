if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx $HOME/dotfiles/xinitrc
fi