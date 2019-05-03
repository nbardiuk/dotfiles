{ pkgs, ... }:
{

  programs.rofi = {
    enable = true;
    font = "Iosevka 14";
    scrollbar = false;
    separator = "none";
    theme = "Arc-Dark";
    extraConfig = ''
      rofi.modi:       window,drun,run,ssh,combi
      rofi.combi-modi: window,drun,run
      rofi.matching:   normal
    '';
  };

}
