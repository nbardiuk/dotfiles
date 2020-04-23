{ pkgs, ... }:
let
  rc = ".config/ripgrep/.ripgreprc";
in
{
  home.file."/${rc}".text = ''
    --smart-case
    --no-ignore
    --hidden
    --glob=!.git
    --glob=!target
    --glob=!node_modules
    --glob=!build
  '';

  home.sessionVariables = {
    RIPGREP_CONFIG_PATH = "$HOME/${rc}";
  };

  home.packages = with pkgs; [
    ripgrep
  ];
}
