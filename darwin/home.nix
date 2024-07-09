{ pkgs, ... }:
{
  imports = [
    ./../home-manager/home/alacritty.nix
    ./../home-manager/home/scala.nix
    ./../home-manager/home/shell.nix
    ./../home-manager/home/syncthing.nix
  ];
  home.packages = with pkgs; [
    keepassxc
    iosevka-bin # monospace font
  ];
  home.stateVersion = "24.05";
}
