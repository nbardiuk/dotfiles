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
      plug.plugins = with pkgs; with vimPlugins; [
        ale
        coc-nvim
        deoplete-nvim
        echodoc-vim
        fzf-vim
        fzfWrapper
        gitgutter
        neco-syntax
        neco-vim
        neoformat
        rhubarb
        rust-vim
        tmux-navigator
        vim-airline
        vim-airline-themes
        vim-colorschemes
        vim-commentary
        vim-fugitive
        vim-ghcid
        vim-hdevtools
        vim-markdown
        vim-merlin
        vim-polyglot
        vim-repeat
        vim-sensible
        vim-surround
        vim-unimpaired
        vim-vinegar
      ];

    };
  };

  home.packages = with pkgs; [
    fzf
    git
    haskellPackages.ghcid
    haskellPackages.hdevtools
    haskellPackages.hindent
    haskellPackages.hlint
    haskellPackages.stylish-haskell
    ripgrep                   # grep for developers
    shellcheck                # shell scripts linter
    stack                     # haskell build tool
    vale                      # prose linter
    vim-vint                  # vim linter
    xclip                     # clipboard manager
    yarn                      # js build tool (used by coc plugins)
  ];
}
