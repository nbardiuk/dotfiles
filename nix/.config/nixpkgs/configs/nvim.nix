{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (import (builtins.fetchTarball https://github.com/domenkozar/hie-nix/tarball/master ) {}).hies
    fzf
    git
    haskellPackages.ghcid
    haskellPackages.hlint
    haskellPackages.stylish-haskell
    neovim                    # editor
    neovim-remote
    nodePackages.javascript-typescript-langserver
    nodejs
    ripgrep                   # grep for developers
    rust_mozilla
    rustracer
    shellcheck                # shell scripts linter
    stack                     # haskell build tool
    vale                      # prose linter
    vim-vint                  # vim linter
    xclip                     # clipboard manager
  ];
}
