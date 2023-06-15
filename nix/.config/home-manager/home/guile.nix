{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    guile
  ];
  home.file.".guile".text = ''
    (use-modules (ice-9 readline))
    (activate-readline)
  '';
}
