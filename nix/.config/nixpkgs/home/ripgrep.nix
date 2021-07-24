{ config, pkgs, ... }:
let
  rc = "ripgrep/.ripgreprc";
in
{
  xdg.configFile.${rc}.text = ''
    --smart-case
    --hidden
    --glob=!.git
  '';

  home.sessionVariables = {
    RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/${rc}";
  };

  home.packages = with pkgs; [
    ripgrep
  ];
}
