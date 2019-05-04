{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./htop.nix
    ./nvim.nix
    ./zsh.nix
  ];

  programs.man.enable = true;

  home.packages = with pkgs; [
    cachix                    # more nix caches
    hledger                   # cli accounting
    ncdu
    nox                       # nix helper
    ranger                    # cli file manager
    tree                      # list files in tree
    w3m                       # cli browser, shows images
    wget
  ];
}
