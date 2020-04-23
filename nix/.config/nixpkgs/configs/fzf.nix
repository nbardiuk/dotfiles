{ pkgs, ... }:
let
  fd-flags = ''--hidden --no-ignore --exclude ".git" --exclude "build" --exclude "target" --exclude "node_modules"'';
in
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = ''fd --type f ${fd-flags}'';
    fileWidgetCommand = ''fd --type f ${fd-flags}'';
    changeDirWidgetCommand = ''fd --type d ${fd-flags}'';
  };

  home.packages = with pkgs; [
    fd
  ];
}
