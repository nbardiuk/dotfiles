{ pkgs, ... }:
let
  enable = true;
in
if !enable then { } else {
  home.packages = with pkgs; [
    postgresql
    pspg
  ];

  home.file.".psqlrc".text = ''
    \set PROMPT1 '\npostgresql://%n@%m:%>/%~\n❯ '
    \set PROMPT2 '  '

    \pset null <NULL>

    \pset expanded

    \set FETCH_COUNT 100

    \timing on

    \setenv PAGER 'pspg -s 16'
    \pset border 2
    \pset linestyle unicode
    \set x '\setenv PAGER less'
    \set xx '\setenv PAGER \'pspg -s 16 -bX --no-mouse\' '
  '';
}
