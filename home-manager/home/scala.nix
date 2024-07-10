{ pkgs, ... }:
let
  enable = true;
in
if !enable then { } else {
  home.packages = with pkgs; [
    jdk21
    sbt
    coursier
    scala-cli
    visualvm
  ];
}
