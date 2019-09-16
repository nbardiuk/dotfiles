{ lib, pkgs, ... }:

with lib;

{
  services.sxhkd = {
    enable = true;
    extraPath = "/run/current-system/sw/bin";
    keybindings = let
      workspaces = [ "'1:Ⅰ'" "'2:Ⅱ'" "'3:Ⅲ'" "'4:Ⅳ'" "'5:Ⅴ'" "'6:Ⅵ'" "'7:Ⅶ'" "'8:Ⅷ'" "'9:Ⅸ'" "'10:Ⅹ'" ];
      workspacesList = concatStringsSep "," workspaces;
    in {
      "super + shift + {r,c}"         = "i3-msg {restart,reload}";
      "super + {s,w}"                 = "i3-msg {stacking,tabbed}";
      "super + {_,shift +} {1-9,0}"   = "i3-msg {workspace,move container to workspace} {${workspacesList}}";
      "super + {_,shift +} {h,j,k,l}" = "i3-msg {focus,move} {left,down,up,right}";
      "super + m"                     = "i3-msg move workspace to output up";
      "super + f"                     = "i3-msg fullscreen";
      "super + t"                     = "i3-msg focus paren";
      "super + ctrl + t"              = "i3-msg focus child";
      "super + ctrl + {h,v}"          = "i3-msg split {v,h}";
      "super + {s,w,e}"               = "i3-msg layout {stacking,tabbed,toggle split}";
      "super + shift + q"             = "i3-msg kill";
      "super + shift + a"             = "i3-msg 'resize grow left  10 px; resize shrink right 10 px'";
      "super + shift + d"             = "i3-msg 'resize grow right 10 px; resize shrink left  10 px'";
      "super + shift + w"             = "i3-msg 'resize grow up    10 px; resize shrink down  10 px'";
      "super + shift + s"             = "i3-msg 'resize grow down  10 px; resize shrink up    10 px'";
      "super + shift + {Left,Right}"  = "i3-msg resize {shrink,grow} width 10 px";
      "super + shift + {Down,Up}"     = "i3-msg resize {shrink,grow} height 10 px";
      "super + shift + space"         = "i3-msg 'floating toggle; resize set 1000 800; move position center'";
      "XF86MonBrightness{Up,Down}"    = "light -{A,U} 5";
      "XF86Audio{Raise,Lower}Volume"  = "amixer set Master 5%{+,-} unmute; pkill -RTMIN+10 i3blocks";
      "super + ctrl + l"              = "xautolock -locknow && exec xset dpms force standby";
      "Print"                         = "maim -us ~/Snapshots/$(date +%s).png";
      "super + Return"                = "alacritty -e zsh";
      "super + d"                     = "rofi -show combi -terminal alacritty";
      "super + Tab"                   = "rofi -show combi -combi-modi window";
      "super + b"                     = "${pkgs.open_book}/bin/open_book.sh";
      "super + c"                     = "${pkgs.connection_toggle}/bin/connection_toggle.py";
      "super + u"                     = "${pkgs.rofimoji}/rofimoji.py";
    };
  };
}
