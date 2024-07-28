{ pkgs, ... }:
let
  enable = true;
in
if !enable then { } else {
  home.packages = with pkgs; [
    jdk21 # java dev kit
    maven # java build tool
    # jetbrains.idea-community-bin
    visualvm
  ];
}
