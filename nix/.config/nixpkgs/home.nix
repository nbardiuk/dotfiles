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
    ./home/k9s.nix
    ./home/obs.nix
    ./home/psql.nix
    ./home/shell.nix
    ./home/sqlite.nix
    ./home/syncthing.nix
    ./home/termite.nix
    ./home/zathura.nix
    ./home/emacs.nix
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
    google-fonts # collection of fonts
    iosevka # monospace font
    keepassxc # password manager
    libreoffice-fresh
    tdesktop # chat app
    transmission-gtk
    # vscode-with-extensions

    # chatterino2
    # streamlink

    # blender
    # geeqie

    # lmms
    # ardour
    # qtractor
    # pianobooster
    # musescore
    # webtorrent_desktop

    # sysstat
    # flamegraph

    slack
    discord
    element-desktop

    zoom-us

    screenkey
    slop

    # kdenlive
    ffmpeg-full
    frei0r

    # josm
    # googleearth


    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/steam.nix
    # steam
    # steam.run

    anki

    gimp

    chrysalis

    plantuml
    nodePackages.mermaid-cli

    aws-vault
    awscli2
    ssm-session-manager-plugin
    amazon-ecr-credential-helper
    drawio

    xsane

    dbeaver
    mysql80
  ];
}
