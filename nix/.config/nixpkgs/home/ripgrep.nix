{ config, pkgs, ... }:
let
  rc = "ripgrep/.ripgreprc";
in
{
  xdg.configFile.${rc}.text = ''
    --smart-case
    --no-ignore
    --hidden
    --glob=!.git
    --glob=!target
    --glob=!node_modules
    --glob=!build
    --glob=!.clj-kondo
    --glob=!.cpcache
  '';

  home.sessionVariables = {
    RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/${rc}";
  };

  home.packages = with pkgs; [
    ripgrep
  ];
}
