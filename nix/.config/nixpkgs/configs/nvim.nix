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
        ale
        deoplete-nvim
        echodoc-vim
        fzf-vim
        fzfWrapper
        ghcid
        gitgutter
        neco-syntax
        neco-vim
        neoformat
        rhubarb
        rust-vim
        tmux-navigator
        tsuquyomi
        typescript-vim
        ultisnips
        vim-airline
        vim-airline-themes
        vim-colorschemes
        vim-commentary
        vim-fugitive
        vim-hdevtools
        vim-markdown
        vim-polyglot
        vim-repeat
        vim-sensible
        vim-snippets
        vim-surround
        vim-tsx
        vim-unimpaired
        vim-vinegar
        vimproc
      ];

    };
  };

  home.packages = with pkgs; [
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
  ];
}
