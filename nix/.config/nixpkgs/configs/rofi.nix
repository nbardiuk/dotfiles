{ pkgs, ... }:
{

  programs.rofi = {
    enable = true;
    font = "Iosevka 14";
    scrollbar = false;
    separator = "none";
    theme = "Arc-Dark";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = ''
      rofi.modi:            window,drun,run,ssh,combi
      rofi.combi-modi:      window,drun,run
      rofi.matching:        normal
      rofi.sorting-method:  fzf
    '';
  };

}
