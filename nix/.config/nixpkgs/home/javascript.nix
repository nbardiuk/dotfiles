{ pkgs, ...}:
let
  enable = true;
in if !enable then {} else {
  home.packages = with pkgs; [
    nodejs
    nodePackages.yarn
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.prettier
  ];
}
