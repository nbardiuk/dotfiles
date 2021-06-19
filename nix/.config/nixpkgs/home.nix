{ pkgs, ... }:
{
  imports = [
    ./home/alacritty.nix
    ./home/clojure.nix
    ./home/javascript.nix
    ./home/rust.nix
    ./home/haskell.nix
    ./home/i3.nix
    ./home/firefox.nix
    ./home/guile.nix
    ./home/java.nix
    ./home/keyboard.nix
    ./home/obs.nix
    ./home/psql.nix
    ./home/shell.nix
    ./home/syncthing.nix
    ./home/termite.nix
    ./home/zathura.nix
  ];

  # How unread and relevant news should be presented
  # when running home-manager build and home-manager switch.
  news.display = "silent";
  fonts.fontconfig.enable = true;

  programs.home-manager = {
    enable = true;
    path = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  };

  programs.command-not-found.enable = true;

  # always starts new services
  systemd.user.startServices = true;

  xdg.enable = true;

  programs.mpv.enable = true;
  programs.mpv.scripts = with pkgs.mpvScripts; [ mpris ];

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
