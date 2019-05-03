{ pkgs, ... }:
{

  imports = [
    ./dunst.nix
    ./rofi.nix
  ];

  xsession.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    config = let
      mod = "Mod4";
      mode_system = "System (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown";
      "bg-color"            = "#2f343f";
      "inactive-bg-color"   = "#2f343f";
      "text-color"          = "#f3f4f5";
      "inactive-text-color" = "#676E7D";
      "urgent-bg-color"     = "#E53935";
      "indicator-color"     = "#00ff00";
    in {
      modifier = mod;
      focus.newWindow = "focus";
      window.border = 1;
      floating = {
        border = 1;
        modifier = mod;
      };
      fonts = ["FontAwesome 10" "Iosevka 10"];
      keybindings =
        let
          WS1 =  "1:Ⅰ";
          WS2 =  "2:Ⅱ";
          WS3 =  "3:Ⅲ";
          WS4 =  "4:Ⅳ";
          WS5 =  "5:Ⅴ";
          WS6 =  "6:Ⅵ";
          WS7 =  "7:Ⅶ";
          WS8 =  "8:Ⅷ";
          WS9 =  "9:Ⅸ";
          WS10 = "10:Ⅹ";
        in {
          "${mod}+Return"           = "exec termite -e zsh";
          "${mod}+Shift+q"          = "kill";
          "${mod}+d"                = "exec rofi -show combi -terminal termite";
          "${mod}+Tab"              = "exec rofi -show combi -combi-modi window";
          "${mod}+c"                = "exec ~/.i3/connection_toggle.py";
          "${mod}+h"                = "focus left";
          "${mod}+j"                = "focus down";
          "${mod}+k"                = "focus up";
          "${mod}+l"                = "focus right";
          "${mod}+Left"             = "focus left";
          "${mod}+Down"             = "focus down";
          "${mod}+Up"               = "focus up";
          "${mod}+Right"            = "focus right";
          "${mod}+Shift+h"          = "move left";
          "${mod}+Shift+j"          = "move down";
          "${mod}+Shift+k"          = "move up";
          "${mod}+Shift+l"          = "move right";
          "${mod}+Shift+Left"       = "move left";
          "${mod}+Shift+Down"       = "move down";
          "${mod}+Shift+Up"         = "move up";
          "${mod}+Shift+Right"      = "move right";
          "${mod}+m"                = "move workspace to output up";
          "${mod}+Ctrl+h"           = "split h";
          "${mod}+Ctrl+v"           = "split v";
          "${mod}+f"                = "fullscreen";
          "${mod}+s"                = "layout stacking";
          "${mod}+w"                = "layout tabbed";
          "${mod}+e"                = "layout toggle split";
          "${mod}+Shift+space"      = "floating toggle; resize set 640 480; move position center";
          "${mod}+space"            = "focus mode_toggle";
          "${mod}+a"                = "focus parent";
          "${mod}+1"                = "workspace ${WS1}";
          "${mod}+2"                = "workspace ${WS2}";
          "${mod}+3"                = "workspace ${WS3}";
          "${mod}+4"                = "workspace ${WS4}";
          "${mod}+5"                = "workspace ${WS5}";
          "${mod}+6"                = "workspace ${WS6}";
          "${mod}+7"                = "workspace ${WS7}";
          "${mod}+8"                = "workspace ${WS8}";
          "${mod}+9"                = "workspace ${WS9}";
          "${mod}+0"                = "workspace ${WS10}";
          "${mod}+Shift+1"          = "move container to workspace ${WS1}";
          "${mod}+Shift+2"          = "move container to workspace ${WS2}";
          "${mod}+Shift+3"          = "move container to workspace ${WS3}";
          "${mod}+Shift+4"          = "move container to workspace ${WS4}";
          "${mod}+Shift+5"          = "move container to workspace ${WS5}";
          "${mod}+Shift+6"          = "move container to workspace ${WS6}";
          "${mod}+Shift+7"          = "move container to workspace ${WS7}";
          "${mod}+Shift+8"          = "move container to workspace ${WS8}";
          "${mod}+Shift+9"          = "move container to workspace ${WS9}";
          "${mod}+Shift+0"          = "move container to workspace ${WS10}";
          "${mod}+Shift+c"          = "reload";
          "${mod}+Shift+r"          = "restart";
          "${mod}+Shift+e"          = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'\"";
          "${mod}+Pause"            = "mode \"${mode_system}\"";
          "${mod}+r"                = "mode \"resize\"";
          "${mod}+Ctrl+l"           = "exec xautolock -locknow && exec xset dpms force standby";
          XF86AudioRaiseVolume      = "exec amixer set Master 5%+ unmute; exec pkill -RTMIN+10 i3blocks";
          XF86AudioLowerVolume      = "exec amixer set Master 5%-;        exec pkill -RTMIN+10 i3blocks";
          XF86MonBrightnessUp       = "exec light -A 5";
          XF86MonBrightnessDown     = "exec light -U 5";
          Print                     = "exec maim -us ~/Snapshots/$(date +%s).png";
      };
      modes = {
        resize = {
          h        = "resize shrink width 10 px or 10 ppt";
          j        = "resize grow height 10 px or 10 ppt";
          k        = "resize shrink height 10 px or 10 ppt";
          l        = "resize grow width 10 px or 10 ppt";
          Left     = "resize shrink width 10 px or 10 ppt";
          Down     = "resize grow height 10 px or 10 ppt";
          Up       = "resize shrink height 10 px or 10 ppt";
          Right    = "resize grow width 10 px or 10 ppt";
          Return   = "mode default";
          Escape   = "mode default";
        };
        "${mode_system}" = {
          e           = "exec --no-startup-id i3-msg exit, mode default";
          s           = "exec --no-startup-id systemctl suspend, mode default";
          h           = "exec --no-startup-id systemctl hibernate, mode default";
          r           = "exec --no-startup-id systemctl reboot, mode default";
          "Shift+s"   = "exec --no-startup-id systemctl poweroff -i, mode default";
          Return      = "mode default";
          Escape      = "mode default";
        };
      };
      colors = {
        background    = "${bg-color}";
        focused = {
          border      = "${bg-color}";
          childBorder = "${bg-color}";
          background  = "${bg-color}";
          text        = "${text-color}";
          indicator   = "${indicator-color}";
        };
        focusedInactive = {
          border      = "${inactive-bg-color}";
          childBorder = "${inactive-bg-color}";
          background  = "${inactive-bg-color}";
          text        = "${inactive-text-color}";
          indicator   = "${indicator-color}";
        };
        unfocused = {
          border      = "${inactive-bg-color}";
          childBorder = "${inactive-bg-color}";
          background  = "${inactive-bg-color}";
          text        = "${inactive-text-color}";
          indicator   = "${indicator-color}";
        };
        urgent = {
          border      = "${urgent-bg-color}";
          childBorder = "${urgent-bg-color}";
          background  = "${urgent-bg-color}";
          text        = "${text-color}";
          indicator   = "${indicator-color}";
        };
      };
      bars = [{
        trayOutput = "primary";
        workspaceNumbers = false;
        statusCommand = "i3blocks -c ~/.i3/i3blocks.conf";
        position = "top";
        colors = {
          background    = "${bg-color}";
          separator     = "#757575";
          focusedWorkspace = {
            border      = "${bg-color}";
            background  = "${bg-color}";
            text        = "${text-color}";
          };
          inactiveWorkspace = {
            border      = "${inactive-bg-color}";
            background  = "${inactive-bg-color}";
            text        = "${inactive-text-color}";
          };
          urgentWorkspace = {
            border      = "${urgent-bg-color}";
            background  = "${urgent-bg-color}";
            text        = "${text-color}";
          };
        };
      }];
      startup = [
        { always = true;  notification = false; command = "feh --bg-scale ~/.wallpaper"; }
        { always = true;  notification = true;  command = "xrandr --output eDP-1-1 --auto --below HDMI-1-1 --primary --output HDMI-1-1 --auto"; }
        { always = true;  notification = false; command = "xset -b"; }
        { always = true;  notification = false; command = "xset s 300 300"; }
        { always = false; notification = true;  command = "nm-applet"; }
        { always = false; notification = true;  command = "dropbox"; }
        { always = false; notification = true;  command = "keepassxc"; }
        { always = false; notification = true;  command = "firefox"; }
      ];
    };
  };

  services.gnome-keyring.enable = true;
  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "i3lock -n -c 000000";
  };

  home.packages = with pkgs; [
    feh                       # image viewer, manages wallpaper
    font-awesome_4            # font for status icons
    google-fonts              # collection of fonts
    i3blocks                  # i3 status line
    i3blocks-brightness       # i3 status line block for brightness
    i3blocks-contrib.bandwidth2
    i3blocks-contrib.battery
    i3blocks-contrib.battery2
    i3blocks-contrib.cpu_usage
    i3blocks-contrib.disk
    i3blocks-contrib.kbdd_layout
    i3blocks-contrib.memory
    i3blocks-contrib.openvpn
    i3blocks-contrib.temperature
    i3blocks-contrib.usb
    i3blocks-contrib.volume
    i3lock
    iosevka-bin               # monospace font
    maim                      # cli screenshot tool
    networkmanagerapplet
    xautolock
    xorg.xrandr               # monitor settings CLI
  ];
}
