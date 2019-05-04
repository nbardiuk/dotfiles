{ pkgs, ... }:
{
  imports = [
    ./configs/i3.nix
    ./configs/keybase.nix
    ./configs/termite.nix
    ./configs/shell.nix
    ./configs/zathura.nix
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
    arandr                    # monitor settings GUI
    cabal-install             # haskell build tool
    chromium
    dropbox
    firefox
    google-fonts              # collection of fonts
    iosevka-bin               # monospace font
    jdk                       # java dev kit
    jetbrains.idea-ultimate   # java ide
    keepassxc                 # password manager
    libreoffice-fresh
    maven                     # java build tool
    mpv-with-scripts
    networkmanagerapplet
    nodejs
    pavucontrol               # pulse audio control GUI
    spotify                   # music streaming
    stack                     # haskell build tool
    tdesktop                  # chat app
    transmission-gtk
    vscode-with-extensions
    xorg.xrandr               # monitor settings CLI
  ];
}
