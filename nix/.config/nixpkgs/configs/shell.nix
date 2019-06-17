{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./htop.nix
    ./nvim.nix
    ./tmux.nix
    ./zsh.nix
  ];

  programs.man.enable = true;

  home.packages = with pkgs; [
    atop
    gnumake
    ncdu
    nodePackages.nodemon
    ranger                    # cli file manager
    tree                      # list files in tree
    w3m                       # cli browser, shows images
    wget
  ];
}
