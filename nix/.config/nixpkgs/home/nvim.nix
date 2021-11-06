{ pkgs, config, lib, ... }:
let
  plugin = { url, rev, sha256 }:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = with lib; (last (splitString "/" url));
      version = rev;
      src = pkgs.fetchgit { inherit url rev sha256; };
    };
  neovim-nightly = rev:
    let url = "https://github.com/nix-community/neovim-nightly-overlay/archive/${rev}.tar.gz"; in
    (import <nixpkgs> { overlays = [ (import (fetchTarball { url = url; })) ]; }).neovim-nightly;
in
{
  programs.neovim = {
    enable = true;
    package = (neovim-nightly "0e5c33b");
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = true;
    withRuby = false;
    extraConfig = "let g:aniseed#env = {'module': 'dotfiles.init'}";
    plugins = with pkgs.vimPlugins; [
      ale
      cmp-buffer # buffer text source for nvim-cmp
      cmp-conjure # conjure source for nvim-cmp
      cmp_luasnip # integrates luasnip with nvim-cmp
      cmp-nvim-lsp # lsp source for nvim-cmp
      cmp-nvim-lua # lua source for nvim-cmp
      cmp-path # filesystem source for nvim-cmp
      cmp-spell # spelling source for nvim-cmp
      ferret
      gitgutter
      hop-nvim
      lispdocs-nvim # clojure docs for conjure
      luasnip # snippets manager
      nvim-cmp # completion mananger
      nvim-lspconfig
      nvim-treesitter
      playground # treesitter playground
      plenary-nvim # for telescope
      rhubarb # github provider for fugitive
      sqlite-lua # for lispdocs-nvim
      tabular
      targets-vim
      telescope-fzf-native-nvim
      telescope-nvim
      telescope-project-nvim
      tmux-navigator
      undotree
      vim-abolish
      vim-commentary
      vim-cool # manages search highlight
      vim-dadbod
      vim-dadbod-completion
      vim-eunuch
      vim-fugitive
      vim-indent-object
      vim-markdown
      vim-matchup
      vim-nix
      vim-projectionist
      vim-repeat
      vim-rsi
      vim-sexp
      vim-sexp-mappings-for-regular-people
      vim-slime
      vim-surround
      vim-terraform
      vim-unimpaired
      vim-vinegar
      (plugin { url = "https://github.com/chrisbra/colorizer"; rev = "826d569"; sha256 = "069f8gqjihjzzv2qmpv3mid55vi52c6yyiijfarxpwmfchby9gc5"; })
      (plugin { url = "https://github.com/diepm/vim-rest-console"; rev = "7b407f4"; sha256 = "1x7qicd721vcb7zgaqzy5kgiqkyj69z1lkl441rc29n6mwncpkjj"; })
      (plugin { url = "https://github.com/lervag/wiki.vim"; rev = "2874332"; sha256 = "1krri3lg8wsbz21q4i1ipi7w7av35gfsk7v126pc2vr1szxs0x7b"; })
      (plugin { url = "https://github.com/Olical/aniseed"; rev = "4bb3a4c"; sha256 = "0sd81pagrrwsig1fjm4ly866wcpq4xqpf810a8q1p2bygjs95chx"; })
      (plugin { url = "https://github.com/Olical/conjure"; rev = "a2831ac"; sha256 = "1r1lz397fga204i4a4g6zbaf457wmvb35kpd9m7n8476iay892j7"; })
      (plugin { url = "https://github.com/Olical/nvim-local-fennel"; rev = "3cf4b30"; sha256 = "10f57jp2c3v28kbznqhs42j8wg7ry7xblczb5w94kp066d7nzdlq"; })
      (plugin { url = "https://github.com/onsails/lspkind-nvim"; rev = "1557ce5"; sha256 = "0qrfrwd7mz311hjmpkjfjg1d2dkar675vflizpj0p09b5dp8zkbv"; })
      (plugin { url = "https://github.com/scr1pt0r/crease.vim"; rev = "b2e5b43"; sha256 = "1yg0p58ajd9xf00sr1y9sjy3nxim8af96svrcsy4yn7xbwk24xgm"; })
      (plugin { url = "https://github.com/tjdevries/astronauta.nvim"; rev = "ea8cae1"; sha256 = "1p8kqww82ibyvjv099r1n2jhzlqmhlvy2dj1gqyp6jg6rzrx9xdq"; })
      (plugin { url = "https://gitlab.com/yorickpeterse/nvim-grey"; rev = "29baaa1"; sha256 = "0dkx7yv1q0p43r1w8mpzjcygpfcqqgpk9d5nz27b81707c7k17kb"; })
      (plugin { url = "https://gitlab.com/yorickpeterse/nvim-pqf"; rev = "d053a33"; sha256 = "1rq5lzl5cj7iz5i87fvkai7c87yqy43c58886710fgkc9zmlgmpf"; })
    ];
  };

  xdg.configFile = with config.lib.file; {
    "nvim/fnl/dotfiles/init.fnl".source = mkOutOfStoreSymlink ./init.fnl;
  };

  home.packages = with pkgs; [
    cachix # to fetch nightly neovim
    nixpkgs-fmt # nix formatter
    clj-kondo # clojure linter
    clojure-lsp
    shellcheck # shell scripts linter
    shfmt # shell scripts formatter
    vim-vint # vim linter
    xsel # clipboard manager
    jq # json formatter
    libxml2 # for xmllint
    pgformatter # sql formatter
    sqlint # sql linter
    python38Packages.python-lsp-server
    ccls
    clang-tools
    cljfmt
    hadolint # dockerfile linter
    fennel
    pandoc # for markdown conversion
  ];
}
