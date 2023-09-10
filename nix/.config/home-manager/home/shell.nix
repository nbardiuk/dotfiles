{ pkgs, ... }:
{
  imports = [
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
    bandwhich # bandwidth monitor per process
    gnumake
    lsof
    ncdu
    watch
    python310Full
    python310Packages.autopep8
    python310Packages.pip
    python310Packages.virtualenv

    eza # fancy ls with tree
    tokei
    wget
    unzip
    unrar

    watchexec
  ];
}
