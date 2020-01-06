{ pkgs, ... }:
let
  rc = ".config/ripgrep/.ripgreprc";
in
{
  home.file."/${rc}".text = ''
    --smart-case
    --no-ignore
  '';

  home.sessionVariables = {
    RIPGREP_CONFIG_PATH = "$HOME/${rc}";
  };

  home.packages = with pkgs; [
    ripgrep
  ];
}
