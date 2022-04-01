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
    python39Full
    python39Packages.autopep8
    python39Packages.pip
    python39Packages.virtualenv

    exa                       # fancy ls with tree
    tokei
    wget
    unzip
    unrar
    perl534Packages.vidir

    watchexec
  ];
}
