{ lib, pkgs, ... }:

with lib;

{
  services.sxhkd = {
    enable = true;
    keybindings = let
      workspaces = [ "'1'" "'2'" "'3'" "'4'" "'5'" "'6'" "'7'" "'8'" "'9'" "'10'" ];
      workspacesList = concatStringsSep "," workspaces;
    in {
      "super + alt + shift + {r,c}"         = "i3-msg {restart,reload}";
      "super + alt + {s,w}"                 = "i3-msg {stacking,tabbed}";
      "super + alt + {_,shift +} {1-9,0}"   = "i3-msg {workspace,move container to workspace} {${workspacesList}}";
      "super + alt + {_,shift +} {h,j,k,l}" = "i3-msg {focus,move} {left,down,up,right}";
      "super + alt + m"                     = "i3-msg move workspace to output up; i3-msg move workspace to output right";
      "super + alt + f"                     = "i3-msg fullscreen";
      "super + alt + t"                     = "i3-msg focus paren";
      "super + alt + ctrl + t"              = "i3-msg focus child";
      "super + alt + ctrl + {h,v}"          = "i3-msg split {v,h}";
      "super + alt + {s,w,e}"               = "i3-msg layout {stacking,tabbed,toggle split}";
      "super + alt + shift + q"             = "i3-msg kill";
      "super + alt + shift + a"             = "i3-msg 'resize grow left  10 px; resize shrink right 10 px'";
      "super + alt + shift + d"             = "i3-msg 'resize grow right 10 px; resize shrink left  10 px'";
      "super + alt + shift + w"             = "i3-msg 'resize grow up    10 px; resize shrink down  10 px'";
      "super + alt + shift + s"             = "i3-msg 'resize grow down  10 px; resize shrink up    10 px'";
      "super + alt + shift + {Left,Right}"  = "i3-msg resize {shrink,grow} width 10 px";
      "super + alt + shift + {Down,Up}"     = "i3-msg resize {shrink,grow} height 10 px";
      "super + alt + shift + space"         = "i3-msg 'floating toggle; resize set 1000 800; move position center'";
      "XF86MonBrightness{Up,Down}"          = "light -{A,U} 5";
      "XF86Audio{Raise,Lower}Volume"        = "amixer set Master 5%{+,-} unmute; pkill -RTMIN+10 i3blocks";
      "super + alt + ctrl + l"              = "xautolock -locknow && exec xset dpms force standby";
      "Print"                               = "maim -us ~/Snapshots/$(date +%s).png";
      "super + alt + Return"                = "alacritty --command zsh";
      "super + alt + d"                     = "rofi -show combi";
      "super + alt + Tab"                   = "rofi -show combi -combi-modi window";
      "super + alt + b"                     = "${pkgs.open_book}/bin/open_book.sh";
      "super + alt + c"                     = "${pkgs.connection_toggle}/bin/connection_toggle.py";
    };
  };
}
