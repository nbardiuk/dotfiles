{ pkgs, ... }:
{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./fzf.nix
    ./ripgrep.nix
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
    bandwhich                 # bandwidth monitor per process
    gnumake
    lsof
    ncdu
    watch
    python38Full
    python38Packages.autopep8
    python38Packages.pip
    python38Packages.virtualenv

    exa                       # fancy ls with tree
    tokei
    wget
    unzip
    unrar

    entr                      # file watcher
  ];
}
