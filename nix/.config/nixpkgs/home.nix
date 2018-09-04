{ pkgs, ... }:
{

  # Configure fontconfig to discover fonts installed through home.packages and nix-env.
  # Note, this is only necessary on non-NixOS systems.
  fonts.fontconfig.enableProfileFonts = true;

  # Enable Syncthing continuous file synchronization.
  services.syncthing.enable = true;

  # Enable manual pages and the man command.
  # This also includes "man" outputs of all home.packages.
  programs.man.enable = true;

  # How unread and relevant news should be presented 
  # when running home-manager build and home-manager switch.
  news.display = "silent";

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    history = {
      expireDuplicatesFirst = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "archlinux"
        "common-aliases"
        "git"
      ];
      theme = "refined";
    };

    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +set\\ filetype=man -";
      PATH = "/home/nbardiuk/.local/bin/:$PATH";
      SUDO_EDITOR = "nvim";
      TERM = "xterm-256color";
    };

    shellAliases = {
      caffeine = "xset s off -dpms && pkill xautolock";
      vim = "nvim";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.rofi = {
    enable = true;
    font = "Iosevka 14";
    scrollbar = false;
    separator = "none";
    theme = "Arc-Dark";
    extraConfig = ''
      rofi.modi:       window,drun,run,ssh,combi
      rofi.combi-modi: window,drun,run
      rofi.matching:   normal
      '';
  };

  programs.termite = {
    enable = true;
    browser = "xdg-open";
    font = "Iosevka Term 12";
    scrollbackLines = -1;
    backgroundColor = "#fdf6e3";
    cursorColor = "#586e75";
    foregroundColor = "#657b83";
    foregroundBoldColor = "#073642";
    colorsExtra = ''
      color0 = #073642
      color1 = #dc322f
      color2 = #859900
      color3 = #b58900
      color4 = #268bd2
      color5 = #d33682
      color6 = #2aa198
      color7 = #eee8d5
      color8 = #002b36
      color9 = #cb4b16
      color10 = #586e75
      color11 = #657b83
      color12 = #839496
      color13 = #6c71c4
      color14 = #93a1a1
      color15 = #fdf6e3
      '';
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
      size = "16x16";
    };
    settings = {
      global = {
        alignment = "left";
        allow_markup = "yes";
        bounce_freq = 0;
        browser = "/usr/bin/firefox -new-tab";
        follow = "mouse";
        font = "Iosevka 12";
        format = "<b>%s</b>\\n%b\\n%p";
        geometry = "400x150-50+50";
        history_length = 20;
        horizontal_padding = 8;
        icon_position = "left";
        idle_threshold = 90;
        ignore_newline = "no";
        indicate_hidden = "yes";
        line_height = 0;
        max_icon_size = 32;
        monitor = 0;
        padding = 8;
        separator_color = "frame";
        separator_height = 2;
        show_age_threshold = 60;
        show_indicators = "no";
        shrink = "no";
        sort = "yes";
        startup_notification = false;
        sticky_history = "yes";
        transparency = 0;
        word_wrap = "yes";
      };
      frame = {
        color = "#2f343f";
        width = 3;
      };
      shortcuts ={
        close = "mod4+mod1+space";
        close_all = "mod4+mod1+shift+space";
        context = "mod4+shift+period";
        history = "mod4+grave";
      };
      urgency_low = {
        background = "#2f343f";
        foreground = "#676E7D";
        timeout = 30;
      };
      urgency_normal = {
        background = "#2f343f";
        foreground = "#f3f4f5";
        timeout = 60;
      };
      urgency_critical = {
        background = "#E53935";
        foreground = "#f3f4f5";
        timeout = 0;
      };
    };
  };

  services.redshift = {
    enable = true;
    tray = true;
    longitude = "-9.13";
    latitude = "38.71";
    temperature = {
      day = 5700;
      night = 3600;
    };
  };

  # The set of packages to appear in the user environment.
  home.packages = with pkgs; [
    # i3blocks                # i3 status line TODO build from git
    acpi                      # status battery
    cabal-install             # haskell build tool
    feh                       # image viewer, manages wallpaper
    font-awesome_4            # font for status icons
    ghc                       # haskell compiler
    gradle                    # java build tool
    gtypist                   # touch typing trainer
    hledger                   # cli accounting
    iosevka-bin               # monospace font
    irssi                     # cli IRC client
    keepassxc                 # password manager
    maven                     # java build tool
    neovim                    # editor
    ranger                    # cli file manager
    sbt                       # scala build tool
    stack                     # haskell build tool
    syncthing                 # files syncronization
    vale                      # prose linter
    vim-vint                  # vim linter
    xautolock                 # locks X session
    xdotool                   # X11 automation
    xkb_switch                # keyboard status
    xorg.xbacklight           # screen brightness TODO fixme
    xorg.xrandr               # monitor settings
  ];
}
