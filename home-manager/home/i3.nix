{ pkgs, ... }:
let
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
    config =
      let
        mod = "Mod4";
        "bg-color" = "#2f343f";
        "inactive-bg-color" = "#2f343f";
        "text-color" = "#f3f4f5";
        "inactive-text-color" = "#676E7D";
        "urgent-bg-color" = "#E53935";
        "indicator-color" = "#00ff00";
      in
      {
        modifier = mod;
        focus.newWindow = "focus";
        window.border = 1;
        window.titlebar = false;
        floating = {
          border = 1;
          modifier = mod;
        };
        fonts.names = [ "FontAwesome" "Iosevka" ];
        fonts.size = 10.0;
        keybindings = { };
        colors = {
          background = "${bg-color}";
          focused = {
            border = "${bg-color}";
            childBorder = "${bg-color}";
            background = "${bg-color}";
            text = "${text-color}";
            indicator = "${indicator-color}";
          };
          focusedInactive = {
            border = "${inactive-bg-color}";
            childBorder = "${inactive-bg-color}";
            background = "${inactive-bg-color}";
            text = "${inactive-text-color}";
            indicator = "${indicator-color}";
          };
          unfocused = {
            border = "${inactive-bg-color}";
            childBorder = "${inactive-bg-color}";
            background = "${inactive-bg-color}";
            text = "${inactive-text-color}";
            indicator = "${indicator-color}";
          };
          urgent = {
            border = "${urgent-bg-color}";
            childBorder = "${urgent-bg-color}";
            background = "${urgent-bg-color}";
            text = "${text-color}";
            indicator = "${indicator-color}";
          };
        };
        bars = [{
          trayOutput = "primary";
          workspaceNumbers = false;
          statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
          position = "top";
          colors = {
            background = "${bg-color}";
            separator = "#757575";
            focusedWorkspace = {
              border = "${bg-color}";
              background = "${bg-color}";
              text = "${text-color}";
            };
            inactiveWorkspace = {
              border = "${inactive-bg-color}";
              background = "${inactive-bg-color}";
              text = "${inactive-text-color}";
            };
            urgentWorkspace = {
              border = "${urgent-bg-color}";
              background = "${urgent-bg-color}";
              text = "${text-color}";
            };
          };
        }];
        startup = [
          { command = "dropbox start -i"; notification = false; }
          { command = "firefox"; }
          { command = "keepassxc"; }
        ];
      };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
            block = "net";
            format_alt = "$ip";
            interval = 1;
          }
          {
            block = "memory";
            format = " $icon $mem_free.eng(w:3,u:B,p:Mi) ($mem_used_percents.eng(w:2)) ";
            interval = 1;
          }
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "cpu";
            interval = 1;
            format = " $icon $utilization ";
            format_alt = " $icon $barchart $utilization ";
          }
          {
            block = "temperature";
            format = "$icon $average";
            format_alt = "$icon $average [$min $max]";
            interval = 1;
          }
          {
            block = "battery";
            device = "DisplayDevice";
            driver = "upower";
          }
          { block = "sound"; }
          { block = "backlight"; }
          {
            block = "keyboard_layout";
            driver = "kbddbus";
          }
          {
            block = "notify";
          }
          {
            block = "time";
            interval = 5;
            format = " $timestamp.datetime(f:'%a %d.%m %R') ";
          }
        ];
        theme = "nord-dark";
        icons = "awesome4";
      };
    };
  };

  services.picom = {
    enable = true;
  };

  xsession.profileExtra = ''
    feh --bg-scale ${wallpaper}

    xset -b
    xset s 300 300
  '';

  services.network-manager-applet.enable = true;

  services.gnome-keyring.enable = true;
  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
  };

  services.blueman-applet.enable = true;
  services.udiskie.enable = true;
  services.pasystray.enable = true; # pulse audio applet

  home.packages = with pkgs; [
    arandr # monitor settings GUI
    feh # image viewer, manages wallpaper
    dejavu_fonts
    font-awesome_4 # font for status icons
    google-fonts # collection of fonts
    xorg.xrandr # monitor settings CLI
    pavucontrol # pulse audio control GUI
    xautolock # screen locker command
    dropbox
    caffeine-ng
    i3status-rust
    kbdd
  ];
}
