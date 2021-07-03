{ pkgs, ... }:
let
  enable = true;
in
if !enable then { } else {
  home.packages = with pkgs; [
    sqlite
  ];

  home.file.".sqliterc".text = ''
    .prompt "\n❯ " "  "

    .mode line

    .nullvalue <NULL>

    .timer OFF
  '';
}
