{ pkgs, ... }:
{

  imports = [
    ./configs/i3.nix
    ./configs/keybase.nix
  ];

  # Configure fontconfig to discover fonts installed through home.packages and nix-env.
  # Note, this is only necessary on non-NixOS systems.
  fonts.fontconfig.enableProfileFonts = true;

  # Enable Syncthing continuous file synchronization.
  services.syncthing = {
    enable = true;
    tray = true;
  };

  # Enable manual pages and the man command.
  # This also includes "man" outputs of all home.packages.
  programs.man.enable = true;

  # How unread and relevant news should be presented
  # when running home-manager build and home-manager switch.
  news.display = "silent";

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-19.03.tar.gz";
  };

  programs.command-not-found.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-linuxbrowser ];
  };

  # Bluetooth applet
  services.blueman-applet.enable = true;

  home.keyboard = {
    layout = "us,ua";
    options = ["grp:shifts_toggle" "ctrl:nocaps"];
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    history.expireDuplicatesFirst = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "bgnotify"
        "common-aliases"
        "git"
      ];
      theme = "refined";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +set\\ filetype=man -";
      SUDO_EDITOR = "nvim";
      TERM = "xterm-256color";
      FZF_DEFAULT_COMMAND="rg --files";
      FZF_CTRL_T_COMMAND="rg --files";
    };

    shellAliases = {
      caffeine = "xset s off -dpms && pkill xautolock";
      vi = "nvim";
      view = "nvim -R";
      upgrade = "sudo sysctl -p && sudo nixos-rebuild switch --upgrade && home-manager switch && nvim +PlugInstall +UpdateRemotePlugins +qa";
    };

    initExtra = ''
      eval $(keychain --eval --quiet ~/.ssh/id_rsa)
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_FIND_NO_DUPS
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
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
      # direnv
      ".envrc"
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

  programs.zathura = {
    enable = true;
    options = {
      continuous-hist-save = true;
      selection-clipboard = "clipboard";
      scroll-page-aware = true;
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
  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  xdg.enable = true;

  nixpkgs.config.allowUnfree = true;
  # The set of packages to appear in the user environment.
  home.packages = with pkgs; [
    (import (builtins.fetchTarball https://github.com/domenkozar/hie-nix/tarball/master ) {}).hies
    ammonite                  # scala repl
    arandr                    # monitor settings GUI
    cabal-install             # haskell build tool
    cabal2nix                 #
    cachix                    # more nix caches
    chromium
    dropbox
    firefox
    fzf
    git
    google-fonts              # collection of fonts
    gradle                    # java build tool
    haskellPackages.ghcid
    haskellPackages.hlint
    haskellPackages.stylish-haskell
    hledger                   # cli accounting
    htop
    iosevka-bin               # monospace font
    jdk                       # java dev kit
    jetbrains.idea-ultimate   # java ide
    keepassxc                 # password manager
    keychain                  # ssh agent
    libreoffice-fresh
    maven                     # java build tool
    mpv-with-scripts
    ncdu
    neovim                    # editor
    neovim-remote
    networkmanagerapplet
    nodejs
    nox                       # nix helper
    pavucontrol               # pulse audio control GUI
    ranger                    # cli file manager
    ripgrep                   # grep for developers
    sbt                       # scala build tool
    shellcheck                # shell scripts linter
    spotify                   # music streaming
    stack                     # haskell build tool
    tdesktop                  # chat app
    transmission-gtk
    tree                      # list files in tree
    vale                      # prose linter
    vim-vint                  # vim linter
    visualvm                  # jvm visual dashboard
    vscode-with-extensions
    w3m                       # cli browser, shows images
    wget
    xclip                     # clipboard manager
    xorg.xrandr               # monitor settings CLI
    youtube-dl                # fetch youtube videos
    zathura                   # pdf/djvu reader
  ];
}
