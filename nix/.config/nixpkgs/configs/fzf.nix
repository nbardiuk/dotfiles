{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = ''fd --type f --hidden --follow --exclude ".git"'';
    fileWidgetCommand = ''fd --type f --hidden --follow --exclude ".git"'';
    fileWidgetOptions = ["--preview 'bat {}'"];
    changeDirWidgetCommand = ''fd --type d --hidden --follow --exclude ".git"'';
    changeDirWidgetOptions = ["--preview 'tree -C --noreport -L 4 -F -a -I .git --dirsfirst {} | bat'"];
  };

  home.packages = with pkgs; [
    fd
  ];
}
