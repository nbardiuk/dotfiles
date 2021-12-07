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
    (import <nixpkgs> { overlays = [ (import (fetchTarball { inherit url; })) ]; }).neovim-nightly;
in
{
  programs.neovim = {
    enable = true;
    package = neovim-nightly "e581701";
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = true;
    withRuby = false;
    extraConfig = "let g:aniseed#env = {'module': 'dotfiles.init'}";
    plugins = with pkgs.vimPlugins; [
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
      luasnip # snippets manager
      nvim-cmp # completion manager
      nvim-lspconfig
      playground # treesitter playground
      plenary-nvim # for telescope, and null-ls
      rhubarb # github provider for fugitive
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
      (plugin { url = "https://github.com/jose-elias-alvarez/null-ls.nvim"; rev = "d597d65"; sha256 = "sha256-gTxlASnmZlXpzyW9QRADR52cM6Da+H17Y6MVrpSr++Q="; })
      (plugin { url = "https://github.com/lervag/wiki.vim"; rev = "ced1e07"; sha256 = "sha256-qJt5GPQewT7YXPzfBiM9QXr/YLdk6M1w3EvjFc/BNd4="; })
      (plugin { url = "https://github.com/nvim-treesitter/nvim-treesitter"; rev = "a47df48"; sha256 = "sha256-AlysBP/Eopb2tkWoLZ7HNvfxVIKzSa6A8EehZQIxe3A="; })
      (plugin { url = "https://github.com/Olical/aniseed"; rev = "9c8f2cd"; sha256 = "sha256-y1XcTvrcKOPhqZKAkHCOaGYNeRUbqCsKNHQJN2PU9sg="; })
      (plugin { url = "https://github.com/Olical/conjure"; rev = "9ed3904"; sha256 = "sha256-3W0+06T6LoG3/xMMXR9P06p5v3HH6KKjmkUWPQSeCnE="; })
      (plugin { url = "https://github.com/Olical/nvim-local-fennel"; rev = "63c4a77"; sha256 = "sha256-EEIxwyLEkR3rsrNBgCHuDnwpDDkI5UKpktlUxN891dg="; })
      (plugin { url = "https://github.com/onsails/lspkind-nvim"; rev = "1557ce5"; sha256 = "0qrfrwd7mz311hjmpkjfjg1d2dkar675vflizpj0p09b5dp8zkbv"; })
      (plugin { url = "https://github.com/scr1pt0r/crease.vim"; rev = "b2e5b43"; sha256 = "1yg0p58ajd9xf00sr1y9sjy3nxim8af96svrcsy4yn7xbwk24xgm"; })
      (plugin { url = "https://github.com/tjdevries/astronauta.nvim"; rev = "edc19d3"; sha256 = "sha256-WFjHi1wS/GOGaBBFoKuz2qXqyhsAKPMPy+kgzS2AJTU="; })
      (plugin { url = "https://gitlab.com/yorickpeterse/nvim-grey"; rev = "29baaa1"; sha256 = "0dkx7yv1q0p43r1w8mpzjcygpfcqqgpk9d5nz27b81707c7k17kb"; })
    ];
  };

  xdg.configFile = with config.lib.file; {
    "nvim/fnl/dotfiles/init.fnl".source = mkOutOfStoreSymlink ./init.fnl;
  };

  home.packages = with pkgs; [
    cachix # to fetch nightly neovim
    nixpkgs-fmt # nix formatter
    clojure-lsp
    shellcheck # shell scripts linter
    shfmt # shell scripts formatter
    xsel # clipboard manager
    jq # json formatter
    libxml2 # for xmllint
    yamllint # yaml linter
    pgformatter # sql formatter
    sqlint # sql linter
    python38Packages.python-lsp-server
    ccls
    clang-tools
    hadolint # dockerfile linter
    fennel
    pandoc # for markdown conversion
    statix # nix linter
    nodePackages.fixjson # json formatter
    terraform-ls
    terraform
    codespell
  ];
}
