{ pkgs, ... }:
let
  vim-colors-github = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-colors-github";
    version = "2018-11-14";
    src = pkgs.fetchFromGitHub {
      owner = "cormacrelf";
      repo = "vim-colors-github";
      rev = "acb712c";
      sha256 = "1nnbyl6qm7rksz4sc0cs5hgpa9sw5mlan732bnn7vn296qm9sjv1";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    withRuby = true;
    extraConfig = builtins.readFile ./init.vim;
    plugins = with pkgs.vimPlugins; [
      ale
      deoplete-nvim
      echodoc-vim
      fzf-vim
      fzfWrapper
      ghcid
      gitgutter
      LanguageClient-neovim
      neco-syntax
      neco-vim
      neoformat
      rhubarb
      rust-vim
      tmux-navigator
      ultisnips
      vim-airline
      vim-airline-themes
      vim-colors-github
      vim-commentary
      vim-fugitive
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

  home.packages = with pkgs; [
    nixfmt                    # nix formatter
    haskellPackages.ghcid
    haskellPackages.hdevtools
    haskellPackages.hindent
    haskellPackages.hlint
    haskellPackages.stylish-haskell
    ripgrep                   # grep for developers
    shellcheck                # shell scripts linter
    stack                     # haskell build tool
    vim-vint                  # vim linter
    xclip                     # clipboard manager
    nodePackages.typescript-language-server
    ccls                      # c/c++ language server
    clang-tools               # clang dev tools
  ];
}
