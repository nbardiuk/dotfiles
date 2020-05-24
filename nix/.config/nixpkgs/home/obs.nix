{ pkgs, ... }:
{
  programs.obs-studio = {
    enable = false;
    plugins = [ pkgs.obs-linuxbrowser ];
  };
}
