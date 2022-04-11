{ pkgs, ...}:
let
  enable = true;
in if !enable then {} else {
  home.packages = with pkgs; [
    jdk                       # java dev kit
    maven                     # java build tool
  ];
}
