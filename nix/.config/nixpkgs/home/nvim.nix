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
    package = neovim-nightly "9a5ef87";
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
      (plugin { url = "https://github.com/jose-elias-alvarez/null-ls.nvim"; rev = "b7de45a"; sha256 = "sha256-9S1IPl58ZBjLqbChVYM92l7Mz1Cg3U9ex5ImFebDuxY="; })
      (plugin { url = "https://github.com/lervag/wiki.vim"; rev = "e233583"; sha256 = "sha256-wbAnMsRO4Lk0o6aJDyyGYh1Av9QcrZx4iQNucYM6Gwk="; })
      (plugin { url = "https://github.com/nvim-treesitter/nvim-treesitter"; rev = "ad69e25"; sha256 = "sha256-RmxYJFh0/Irdhaf9mTBK22CRyIZIiYZ3jwv0Z5ZgchM="; })
      (plugin { url = "https://github.com/Olical/aniseed"; rev = "7968693"; sha256 = "sha256-BMwTcwGEEB/n9AXgN1j/KpD1/ECrLjhHxRNOk02KXkk="; })
      (plugin { url = "https://github.com/Olical/conjure"; rev = "2717348"; sha256 = "sha256-GA4buzcA6ElqVjSeCgD+OjsqbB5IlDbbYtZyrYEs9rk="; })
      (plugin { url = "https://github.com/Olical/nvim-local-fennel"; rev = "5770299"; sha256 = "sha256-+dGoOXgp67tI8w0aVMcTrAgaLBh0a30csSZVWCz2xRg="; })
      (plugin { url = "https://github.com/onsails/lspkind-nvim"; rev = "f3b5efa"; sha256 = "sha256-qIs65OIV0m5Y3pe5ozG6sYa1yIx0vXpkNC0Gkkm9amw="; })
      (plugin { url = "https://github.com/scr1pt0r/crease.vim"; rev = "b2e5b43"; sha256 = "1yg0p58ajd9xf00sr1y9sjy3nxim8af96svrcsy4yn7xbwk24xgm"; })
      (plugin { url = "https://github.com/tjdevries/astronauta.nvim"; rev = "edc19d3"; sha256 = "sha256-WFjHi1wS/GOGaBBFoKuz2qXqyhsAKPMPy+kgzS2AJTU="; })
      (plugin { url = "https://gitlab.com/yorickpeterse/nvim-grey"; rev = "41fb14e8"; sha256 = "sha256-466vFz8fq+r1JesrxYR0WtO1ffX/DqkuG2Zc10OEdFk="; })
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
