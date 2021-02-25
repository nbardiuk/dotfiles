{ pkgs, ... }:
{

  programs.rofi = {
    enable = true;
    font = "Iosevka 14";
    scrollbar = false;
    separator = "none";
    theme = "Arc-Dark";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      modi = "window,drun,run,ssh,combi";
      combi-modi = "window,drun,run";
      matching = "normal";
      sorting-method = "fzf";
    };
  };

}
