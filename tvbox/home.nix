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
    google-fonts # collection of fonts
    iosevka-bin # monospace font
    keepassxc # password manager
    qbittorrent
    yt-dlp
    protonvpn-gui
    nautilus
    remmina
    vlc
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "18.09";

  home.username = "nazarii";
  home.homeDirectory = "/home/nazarii";
}
