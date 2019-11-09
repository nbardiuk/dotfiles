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
  wiki-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "wiki-vim";
    version = "2019-11-02";
    src = pkgs.fetchFromGitHub {
      owner = "lervag";
      repo = "wiki.vim";
      rev = "cb74e7a99213fa00b778c2343ae1a848f7c1b690";
      sha256 = "0h88g82ywb8w51yqhzcl7r9n2yfis9wjnl04wg95l8mnv7hxmzyf";
    };
  };
  fzf-filemru = pkgs.vimUtils.buildVimPlugin {
    pname = "fzf-filemru";
    version = "2018-11-02";
    src = pkgs.fetchFromGitHub {
      owner = "tweekmonster";
      repo = "fzf-filemru";
      rev = "090087d";
      sha256 = "1axhq42cs4hf889adfhfy8h9hf5shbn9snxkz83razxbwc9vdjlq";
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
      fzf-filemru
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
      wiki-vim
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
