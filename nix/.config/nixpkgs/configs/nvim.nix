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
  vim-iced = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-iced";
    version = "2019-11-30";
    src = pkgs.fetchFromGitHub {
      owner = "liquidz";
      repo = "vim-iced";
      rev = "d4eef2c";
      sha256 = "0zd6gnvwx3h47500b0b0h54vyx3x7fld5sc7w80200skzzxdybm3";
    };
    buildPhase = ":";
    postInstall=''
      install -Dt $out/bin $out/share/vim-plugins/vim-iced/bin/iced
    '';
  };
  loadPlugin = plugin: ''
    set rtp^=${plugin.rtp}
    set rtp+=${plugin.rtp}/after
  '';
  plugins = with pkgs.vimPlugins; [
    ale
    float-preview-nvim
    fzf-filemru
    fzf-vim
    fzfWrapper
    ghcid
    gitgutter
    LanguageClient-neovim
    ncm2
    ncm2-bufword
    ncm2-path
    ncm2-tmux
    neoformat
    nvim-yarp # remote plugin manager for ncm2
    rhubarb # github provider for fugitive
    tmux-navigator
    vim-colors-github
    vim-commentary
    vim-dispatch
    vim-fugitive
    vim-iced
    vim-polyglot
    vim-repeat
    vim-sensible
    vim-sexp
    vim-sexp-mappings-for-regular-people
    vim-surround
    vim-unimpaired
    vim-vinegar
    wiki-vim
  ];
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
    extraConfig = builtins.concatStringsSep "\n" [
      ''
        " Workaround for broken handling of packpath by vim8/neovim for ftplugins -- see https://github.com/NixOS/nixpkgs/issues/39364#issuecomment-425536054 for more info
        filetype off | syn off
        ${builtins.concatStringsSep "\n" (map loadPlugin plugins)}
        filetype indent plugin on | syn on
      ''
      (builtins.readFile ./init.vim)
    ];
  };

  home.packages = with pkgs; [
    vim-iced
    ripgrep                   # grep for developers
    shellcheck                # shell scripts linter
    vim-vint                  # vim linter
    xclip                     # clipboard manager
    nodePackages.typescript-language-server
    ccls                      # c/c++ language server
    clang-tools               # clang dev tools
  ];
}
