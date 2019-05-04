{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    cachix                    # more nix caches
    hledger                   # cli accounting
    htop
    ncdu
    nox                       # nix helper
    ranger                    # cli file manager
    tree                      # list files in tree
    w3m                       # cli browser, shows images
    wget
  ];
}
