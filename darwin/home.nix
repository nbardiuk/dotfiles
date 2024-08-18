{ pkgs, ... }:
{
  imports = [
    ./../home-manager/home/alacritty.nix
    ./../home-manager/home/clojure.nix
    ./../home-manager/home/java.nix
    ./../home-manager/home/javascript.nix
    ./../home-manager/home/idea.nix
    ./../home-manager/home/k9s.nix
    ./../home-manager/home/psql.nix
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
