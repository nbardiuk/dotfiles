{ lib, pkgs, ... }:
let
  fd-flags = lib.concatStringsSep " " [
    "--hidden"
    "--exclude '.git'"
  ];
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
