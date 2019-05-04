{ pkgs, ... }:
{
  imports = [
    ./configs/java.nix
    ./configs/haskell.nix
    ./configs/i3.nix
    ./configs/keybase.nix
    ./configs/keyboard.nix
    ./configs/redshift.nix
    ./configs/shell.nix
    ./configs/syncthing.nix
    ./configs/termite.nix
    ./configs/zathura.nix
  ];

  # Configure fontconfig to discover fonts installed through home.packages and nix-env.
  # Note, this is only necessary on non-NixOS systems.
  fonts.fontconfig.enableProfileFonts = true;

  # How unread and relevant news should be presented
  # when running home-manager build and home-manager switch.
  news.display = "silent";

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-19.03.tar.gz";
  };

  programs.command-not-found.enable = true;

  # Bluetooth applet
  services.blueman-applet.enable = true;

  services.udiskie.enable = true;

  xdg.enable = true;

  # The set of packages to appear in the user environment.
  home.packages = with pkgs; [
    chromium
    dropbox
    firefox
    google-fonts              # collection of fonts
    iosevka-bin               # monospace font
    keepassxc                 # password manager
    libreoffice-fresh
    mpv-with-scripts
    nodejs
    pavucontrol               # pulse audio control GUI
    spotify                   # music streaming
    tdesktop                  # chat app
    transmission-gtk
    vscode-with-extensions
  ];
}
