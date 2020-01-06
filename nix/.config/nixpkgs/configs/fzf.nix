{ pkgs, ... }:
let
  fd-flags = ''--hidden --no-ignore --follow --exclude ".git"'';
in
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = ''fd --type f ${fd-flags}'';
    fileWidgetCommand = ''fd --type f ${fd-flags}'';
    fileWidgetOptions = ["--preview 'bat {}'"];
    changeDirWidgetCommand = ''fd --type d ${fd-flags}'';
    changeDirWidgetOptions = ["--preview 'tree -C --noreport -L 4 -F -a -I .git --dirsfirst {} | bat'"];
  };

  home.packages = with pkgs; [
    fd
  ];
}
