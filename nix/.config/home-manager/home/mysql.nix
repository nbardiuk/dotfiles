{ pkgs, ... }:
let
  enable = false;
in
if !enable then { } else {
  home.packages = with pkgs; [
    mysql80
  ];

  home.file.".my.cnf".text = ''
    [mysql]
    prompt="\\u@\\h/\\d\n❯ "
    disable-auto-rehash
    auto-vertical-output
    skip-binary-as-hex
  '';
}
