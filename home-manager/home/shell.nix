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
    # bandwhich # bandwidth monitor per process
    gnumake
    lsof
    ncdu
    watch

    (pkgs.python3.withPackages (ps: [
      ps.autopep8
      ps.pip
      ps.virtualenv
      ps.python-lsp-server
    ] ++ ps.python-lsp-server.optional-dependencies.all))

    eza # fancy ls with tree
    tokei
    wget
    unzip
    unrar

    watchexec

    process-compose

    tcpdump
    usbutils
  ];
}
