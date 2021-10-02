{ pkgs, config, ... }:
{
  xdg.configFile = with config.lib.file; {
    "emacs/init.el".source = mkOutOfStoreSymlink ./init.el;
  };
  home.packages = with pkgs; [
    emacs
    python38Packages.python-lsp-server
    nixpkgs-fmt
  ];
}
