{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config.theme = "ansi-light";
  };
}
