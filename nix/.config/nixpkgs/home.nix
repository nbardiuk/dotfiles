{ pkgs, ... }:
{
  imports = [
    ./configs/i3.nix
    ./configs/keybase.nix
    ./configs/nvim.nix
    ./configs/termite.nix
    ./configs/shell.nix
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

  xdg.enable = true;

  nixpkgs.config.allowUnfree = true;
  # The set of packages to appear in the user environment.
  home.packages = with pkgs; [
    ammonite                  # scala repl
    arandr                    # monitor settings GUI
    cabal-install             # haskell build tool
    cabal2nix                 #
    cachix                    # more nix caches
    chromium
    dropbox
    firefox
    google-fonts              # collection of fonts
    gradle                    # java build tool
    hledger                   # cli accounting
    htop
    iosevka-bin               # monospace font
    jdk                       # java dev kit
    jetbrains.idea-ultimate   # java ide
    keepassxc                 # password manager
    libreoffice-fresh
    maven                     # java build tool
    mpv-with-scripts
    ncdu
    networkmanagerapplet
    nodejs
    nox                       # nix helper
    pavucontrol               # pulse audio control GUI
    ranger                    # cli file manager
    sbt                       # scala build tool
    spotify                   # music streaming
    stack                     # haskell build tool
    tdesktop                  # chat app
    transmission-gtk
    tree                      # list files in tree
    visualvm                  # jvm visual dashboard
    vscode-with-extensions
    w3m                       # cli browser, shows images
    wget
    xorg.xrandr               # monitor settings CLI
    youtube-dl                # fetch youtube videos
    zathura                   # pdf/djvu reader
  ];
}
