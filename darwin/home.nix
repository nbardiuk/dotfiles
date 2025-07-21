{ pkgs, ... }:
{
  imports = [
    ./../home-manager/home/alacritty.nix
    ./../home-manager/home/clojure.nix
    ./../home-manager/home/java.nix
    ./../home-manager/home/javascript.nix
    ./../home-manager/home/psql.nix
    ./../home-manager/home/shell.nix
    ./../home-manager/home/syncthing.nix
    ./../home-manager/home/firefox.nix
  ];
  home.packages = with pkgs; [
    obsidian
    iosevka-bin # monospace font
    keepassxc
    flyctl
    flameshot
    yt-dlp
  ];
  home.stateVersion = "24.05";
  xdg.enable = true;
}
