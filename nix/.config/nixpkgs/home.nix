{ pkgs, ... }:
{
  imports = [
    ./configs/alacritty.nix
    ./configs/clojure.nix
    ./configs/javascript.nix
    ./configs/haskell.nix
    ./configs/i3.nix
    ./configs/firefox.nix
    ./configs/java.nix
    ./configs/keyboard.nix
    ./configs/obs.nix
    ./configs/redshift.nix
    ./configs/shell.nix
    ./configs/syncthing.nix
    ./configs/termite.nix
    ./configs/zathura.nix
  ];

  # How unread and relevant news should be presented
  # when running home-manager build and home-manager switch.
  news.display = "silent";

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-20.03.tar.gz";
  };

  programs.command-not-found.enable = true;

  # always starts new services
  systemd.user.startServices = true;

  xdg.enable = true;

  programs.mpv.enable = true;
  programs.mpv.scripts = with pkgs.mpvScripts; [mpris];

  # The set of packages to appear in the user environment.
  home.packages = with pkgs; [
    chromium
    dropbox
    google-fonts              # collection of fonts
    iosevka-bin               # monospace font
    keepassxc                 # password manager
    #libreoffice-fresh
    tdesktop                  # chat app
    transmission-gtk
    vscode-with-extensions
  ];
}
