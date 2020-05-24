{ pkgs, ...}:
let
  enable = false;
in if !enable then {} else {
  home.packages = with pkgs; [
    jdk                       # java dev kit
    jetbrains.idea-ultimate   # java ide
    maven                     # java build tool
    gradle
  ];
}
