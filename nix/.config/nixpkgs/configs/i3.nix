{ pkgs, ... }:
let
  i3blocksConfig = pkgs.copyPathToStore ./i3blocks.conf;
  wallpaper = pkgs.copyPathToStore ./wallpaper.jpeg;
in
{

  imports = [
    ./dunst.nix
    ./gui.nix
    ./rofi.nix
    ./sxhkd.nix
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
      keybindings = {};
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
        statusCommand = "i3blocks -c ${i3blocksConfig}";
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
        { always = true;  notification = false; command = "feh --bg-scale ${wallpaper}"; }
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

  services.blueman-applet.enable = true;
  services.udiskie.enable = true;

  home.packages = with pkgs; [
    arandr                    # monitor settings GUI
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
