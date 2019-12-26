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
    version = "2019-12-13";
    src = pkgs.fetchFromGitHub {
      owner = "lervag";
      repo = "wiki.vim";
      rev = "002d09e67876235ba84dc294b71f888058f64150";
      sha256 = "1jgqvgaad96rd663rvz8j4pz59fj31zsbz78mywdrrv2d31imxna";
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
