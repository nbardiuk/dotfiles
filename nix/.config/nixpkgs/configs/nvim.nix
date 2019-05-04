{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    withRuby = true;
    configure = {
      customRC = builtins.readFile ./init.vim;
      plug.plugins = with pkgs.vimPlugins; [
        deoplete-nvim
        fzf-vim
        fzfWrapper
        gitgutter
        LanguageClient-neovim
        neco-syntax
        neco-vim
        neoformat
        neomake
        rust-vim
        vim-colorschemes
        vim-commentary
        vim-fugitive
        vim-markdown
        vim-polyglot
        vim-sensible
        vim-surround
        vim-unimpaired
        vim-vinegar
        vimwiki
      ];

    };
  };

  home.packages = with pkgs; [
    (import (builtins.fetchTarball https://github.com/domenkozar/hie-nix/tarball/master ) {}).hies
    fzf
    git
    haskellPackages.ghcid
    haskellPackages.hlint
    haskellPackages.stylish-haskell
    nodePackages.javascript-typescript-langserver
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
