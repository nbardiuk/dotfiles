{ pkgs, config, ... }:
{
  xdg.configFile = with config.lib.file; {
    "emacs/init.el".source = mkOutOfStoreSymlink ./init.el;
  };
  home.packages = with pkgs; [
    emacs
    python38Packages.python-lsp-server
    nixpkgs-fmt
    aspell
    aspellDicts.uk
    aspellDicts.en
    aspellDicts.en-science
    aspellDicts.en-computers
    aspellDicts.pt_PT
  ];
}
