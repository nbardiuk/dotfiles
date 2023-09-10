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
          statusCommand = "i3blocks -c ${i3blocksConfig}";
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
  services.caffeine.enable = true;

  home.packages = with pkgs; [
    arandr # monitor settings GUI
    feh # image viewer, manages wallpaper
    dejavu_fonts
    font-awesome_4 # font for status icons
    google-fonts # collection of fonts
    i3blocks # i3 status line
    i3blocks-brightness # i3 status line block for brightness
    i3blocks-contrib.bandwidth2
    i3blocks-contrib.battery2
    i3blocks-contrib.cpu_usage
    i3blocks-contrib.disk
    i3blocks-contrib.kbdd_layout
    i3blocks-contrib.memory
    i3blocks-contrib.temperature
    i3blocks-contrib.usb
    i3blocks-contrib.volume
    xorg.xrandr # monitor settings CLI
    pavucontrol # pulse audio control GUI
    xautolock # screen locker command
    dropbox
  ];


  services.autorandr.enable = true;
  programs.autorandr.enable = true;
  programs.autorandr.profiles = {
    laps = {
      fingerprint = {
        eDP-1 = "00ffffffffffff0009e5ca0a00000000231f0104a522157803db25a5554b99250f5054000000010101010101010101010101010101016d5600c8a04046603020360058d710000018000000fd00305a969629010a202020202020000000fe00424f452043510a202020202020000000fe004e4531363051444d2d4e36340a01ff70137900000301140ba20085ff09c7002f001f003f0645000200050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007c90";
      };
      config = {
        HDMI-1.enable = false;
        eDP-1 = {
          enable = true;
          primary = true;
          crtc = 0;
          position = "0x0";
          mode = "1920x1080";
          rate = "60.00";
        };
      };
    };
    table = {
      fingerprint = {
        eDP-1 = "00ffffffffffff0009e5ca0a00000000231f0104a522157803db25a5554b99250f5054000000010101010101010101010101010101016d5600c8a04046603020360058d710000018000000fd00305a969629010a202020202020000000fe00424f452043510a202020202020000000fe004e4531363051444d2d4e36340a01ff70137900000301140ba20085ff09c7002f001f003f0645000200050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007c90";
        HDMI-1 = "00ffffffffffff000469a32733f30000011a0103803c22782aa595aa544fa1260a5054b7ef00d1c0b300950081808140810081c0714f565e00a0a0a029503020350055502100001a000000ff0047314c4d54463036323235390a000000fd00184c186321000a202020202020000000fc00415355532050423237380a2020015002032571520102031112130414050e0f1d1e1f90202122230917078301000065030c0010008c0ad08a20e02d10103e9600555021000018011d007251d01e206e28550055502100001e011d00bc52d01e20b828554055502100001e8c0ad090204031200c40550055502100001800000000000000000000000000000000000098";
      };
      config = {
        HDMI-1 = {
          enable = true;
          primary = true;
          crtc = 0;
          position = "0x0";
          mode = "2560x1440";
          rate = "59.95";
        };
        eDP-1 = {
          enable = true;
          primary = false;
          crtc = 1;
          position = "2560x0";
          mode = "2560x1600";
          rate = "90.00";
        };
      };
    };
  };
}
