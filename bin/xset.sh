#!/bin/sh

xhost - >/dev/null
xmodmap $HOME/.xmodmap-pc
xset b off
xset r rate 400 30
xset dpms 0 0 1200
if command -v synclient >/dev/null; then
  synclient \
	  TapButton1=1 \
	  TapButton2=2 \
	  TapButton3=3 \
	  SingleTapTimeout=50 \
	  #HorizTwoFingerScroll=1
fi

xrdb $HOME/.Xdefaults
if [ -f $HOME/.Xdefaults-local ]; then
  xrdb -merge $HOME/.Xdefaults-local
fi
