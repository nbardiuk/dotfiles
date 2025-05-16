{ lib, pkgs, mypkgs, ... }:

with lib;

{
  services.sxhkd = {
    enable = true;
    keybindings = let
      workspaces = [ "'1'" "'2'" "'3'" "'4'" "'5'" "'6'" "'7'" "'8'" "'9'" "'10'" ];
      workspacesList = concatStringsSep "," workspaces;
    in {
      "super + alt + {r,c}"          = "i3-msg {restart,reload}";
      "super + {1-9,0}"              = "i3-msg workspace {${workspacesList}}";
      "super + alt + {1-9,0}"        = "w={${workspacesList}}; i3-msg move workspace $w; i3-msg workspace $w";
      "super + {_,alt +} {h,j,k,l}"  = "i3-msg {focus,move} {left,down,up,right}";
      "super + m"                    = "i3-msg move workspace to output up; i3-msg move workspace to output right";
      "super + f"                    = "i3-msg fullscreen";
      "super + t"                    = "i3-msg focus paren";
      "super + alt + t"              = "i3-msg focus child";
      "super + alt + {h,v}"          = "i3-msg split {v,h}";
      "super + {s,w,e}"              = "i3-msg layout {stacking,tabbed,toggle split}";
      "super + alt + q"              = "i3-msg kill";
      "super + alt + a"              = "i3-msg 'resize grow left  10 px; resize shrink right 10 px'";
      "super + alt + d"              = "i3-msg 'resize grow right 10 px; resize shrink left  10 px'";
      "super + alt + w"              = "i3-msg 'resize grow up    10 px; resize shrink down  10 px'";
      "super + alt + s"              = "i3-msg 'resize grow down  10 px; resize shrink up    10 px'";
      "super + alt + {Left,Right}"   = "i3-msg resize {shrink,grow} width 10 px";
      "super + alt + {Down,Up}"      = "i3-msg resize {shrink,grow} height 10 px";
      "super + alt + space"          = "i3-msg 'floating toggle; resize set 1000 800; move position center'";
      "XF86MonBrightness{Up,Down}"   = "light -{A,U} 5";
      "XF86Audio{Raise,Lower}Volume" = "${pkgs.alsa-utils}/bin/amixer set Master 1%{+,-} unmute";
      "super + ctrl + l"             = "loginctl lock-session && exec xset dpms force standby";
      "super + Return"               = "alacritty";
      "super + d"                    = "rofi -modi drun -show drun";
      "super + Tab"                  = "rofi -modi window -show window";
      "super + ctrl + b"             = "${mypkgs.open_book}/bin/open-book";
      "super + ctrl + c"             = "${mypkgs.connection_toggle}/bin/connection-toggle";
      "super + ctrl + k"             = "${mypkgs.keyboard_toggle}/bin/keyboard-toggle";
      "super + ctrl + e"             = "${pkgs.rofimoji}/bin/rofimoji";
      "super + ctrl + comma"         = "dunstctl history-pop";
      "super + ctrl + slash"         = "dunstctl close";
      "super + ctrl + period"        = "dunstctl context";
      "Print"                        = "flameshot gui";
      "shift + Print"                = "flameshot full";
      "ctrl + Print"                 = "flameshot screen";
      "super + ctrl + p"             = "CM_LAUNCHER=rofi clipmenu -i -p clipmenu";
    };
  };
}
