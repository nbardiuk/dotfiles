{ pkgs, ... }:
{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./htop.nix
    ./nvim.nix
    ./tmux.nix
    ./vale.nix
    ./zsh.nix
  ];

  programs.man.enable = true;

  home.packages = with pkgs; [
    atop
    gnumake
    lsof
    ncdu

    ranger                    # cli file manager
    w3m                       # cli browser, shows images
    mediainfo # media details preview

    exa                       # fancy ls with tree
    tokei
    wget
    unzip
    unrar

    entr                      # file watcher
  ];
}
