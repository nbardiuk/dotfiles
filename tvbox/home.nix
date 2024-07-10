{ pkgs, ... }:
{
  imports = [
    ../home-manager/home/alacritty.nix
    ../home-manager/home/i3.nix
    ../home-manager/home/firefox.nix
    ../home-manager/home/keyboard.nix
    ../home-manager/home/mpv.nix
    ../home-manager/home/shell.nix
    ../home-manager/home/syncthing.nix
    ../home-manager/home/zathura.nix
  ];

  fonts.fontconfig.enable = true;

  programs.command-not-found.enable = true;

  # always starts new services
  systemd.user.startServices = true;

  xdg.enable = true;

  # The set of packages to appear in the user environment.
  home.packages = with pkgs; [
    chromium
    google-fonts # collection of fonts
    iosevka-bin # monospace font
    keepassxc # password manager
    libreoffice-fresh
    tdesktop # chat app
    qbittorrent

    yt-dlp

    # webtorrent_desktop

    protonvpn-gui

    chrysalis

    xsane

    gnome.nautilus
    flameshot


    scrcpy # android control
    gnirehtet # android reverse tethering
    # libsForQt5.kdeconnect-kde # kde connect remote android

    v4l-utils # video4linux devices

    obsidian # notes
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "18.09";

  home.username = "nazarii";
  home.homeDirectory = "/home/nazarii";
}
