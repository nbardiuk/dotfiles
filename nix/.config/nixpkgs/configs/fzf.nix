{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files";
    fileWidgetCommand = "rg --files";
  };

  home.packages = with pkgs; [
    ripgrep
  ];
}
