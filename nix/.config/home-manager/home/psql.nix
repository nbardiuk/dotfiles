{ pkgs, ... }:
let
  enable = true;
in
if !enable then { } else {
  home.packages = with pkgs; [
    postgresql
  ];

  home.file.".psqlrc".text = ''
    \set PROMPT1 '\npostgresql://%n@%m:%>/%~\n❯ '
    \set PROMPT2 '  '

    \pset null <NULL>

    \pset format wrapped
    \pset linestyle old-ascii

    \pset expanded

    \set FETCH_COUNT 100

    \timing

    -- turn off the pager, paginate with tmux
    \pset pager
  '';
}
