{ pkgs, ...}:
let
  enable = false;
in if !enable then {} else {
  home.packages = with pkgs; [
    nodejs
    nodePackages.yarn
    nodePackages.typescript-language-server
    nodePackages.prettier
  ];
}
