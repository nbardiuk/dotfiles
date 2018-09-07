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

  programs.git = {
    enable = true;
    userName = "Nazarii Bardiuk";
    userEmail = "";
    ignores = [
      # idea
      ".idea/" ".idea_modules/" "*.iml" "*.ipr"
      # Vim
      ".sw[a-p]" ".*.sw[a-p]" "Session.vim" ".netrwhist" "*~" "tags"
      # sbt
      "dist/*" "target/" "lib_managed/" "src_managed/" "project/boot/" "project/plugins/project/" ".history" ".cache" ".lib/"
      # Gradle
      ".gradle" "**/build/" "gradle-app.setting" ".gradletasknamecache"
      # Haskell 
      "dist" "dist-*" "cabal-dev" "*.o" "*.hi" "*.chi" "*.chs.h" "*.dyn_o" "*.dyn_hi" ".hpc" ".hsenv" ".cabal-sandbox/" "cabal.sandbox.config" "*.prof" "*.aux" "*.hp" "*.eventlog" ".stack-work/" "cabal.project.local" "cabal.project.local~" ".HTF/" ".ghc.environment.*"
    ];
    extraConfig = {
      code.editor = "nvim";
      diff.tool = "vdiff";
      "difftool \"vdiff\"".cmd = "nvim -d $LOCAL $REMOTE";
      difftool.promt = true;
      merge.tool = "vmerge";
      "mergetool \"vmerge\"".cmd = "nvim -d $LOCAL $REMOTE $MERGED -c 'wincmd w' -c 'wincmd J'";
      mergetool.promt = true;
    };
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

  services.gnome-keyring.enable = true;
  programs.ssh.enable = true;
  services.udiskie.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
      package = pkgs.dejavu_fonts;
    };
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };
    theme = {
      name = "Arc-Darker";
      package = pkgs.arc-theme;
    };
  };

  xdg.enable = true;
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
          XF86MonBrightnessUp       = "exec xbacklight -inc 5";
          XF86MonBrightnessDown     = "exec xbacklight -dec 5";
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
        { always = true;  notification = true;  command = "xrandr --output eDP1 --mode 1920x1080"; }
        { always = true;  notification = true;  command = "xrandr --output HDMI1 --auto --above eDP1"; }
        { always = true;  notification = false; command = "xrdb ~/.Xresources"; }
        { always = true;  notification = false; command = "setxkbmap -model pc104 -layout us,ua  -option grp:shifts_toggle -option ctrl:nocaps"; }
        { always = true;  notification = false; command = "xset -b off"; }
        { always = true;  notification = false; command = "xset s 300 300"; }
        { always = true;  notification = false; command = "xautolock -time 5 -locker \"i3lock -c 000000\""; }
        { always = false; notification = false; command = "nm-applet"; }
        { always = false; notification = false; command = "dropbox"; }
        { always = false; notification = false; command = "keepassxc"; }
        { always = false; notification = false; command = "firefox"; }
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  # The set of packages to appear in the user environment.
  home.packages = with pkgs; [
    # i3blocks                # i3 status line TODO build from git
    acpi                      # status battery
    ammonite                  # scala repl
    cabal-install             # haskell build tool
    feh                       # image viewer, manages wallpaper
    font-awesome_4            # font for status icons
    ghc                       # haskell compiler
    gradle                    # java build tool
    gtypist                   # touch typing trainer
    hledger                   # cli accounting
    i3lock                    # screen lock app
    iosevka-bin               # monospace font
    irssi                     # cli IRC client
    jetbrains.idea-ultimate   # java ide
    keepassxc                 # password manager
    maim                      # cli screenshot tool
    maven                     # java build tool
    neovim                    # editor
    ranger                    # cli file manager
    sbt                       # scala build tool
    stack                     # haskell build tool
    vale                      # prose linter
    vim-vint                  # vim linter
    w3m                       # cli browser, shows images
    xautolock                 # locks X session
    xkb_switch                # keyboard status
    xorg.xbacklight           # screen brightness TODO fixme
    xorg.xrandr               # monitor settings
    zathura                   # pdf/djvu reader
  ];
}
