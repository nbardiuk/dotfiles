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
    package = neovim-nightly "be68a63";
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
      cmp-treesitter # tree sitter source for nvim-cmp
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
      vim-projectionist
      vim-repeat
      vim-rsi
      vim-sexp
      vim-sexp-mappings-for-regular-people
      vim-slime
      vim-surround
      vim-unimpaired
      vim-vinegar
      (plugin { url = "https://github.com/chrisbra/colorizer"; rev = "826d569"; sha256 = "069f8gqjihjzzv2qmpv3mid55vi52c6yyiijfarxpwmfchby9gc5"; })
      (plugin { url = "https://github.com/diepm/vim-rest-console"; rev = "7b407f4"; sha256 = "1x7qicd721vcb7zgaqzy5kgiqkyj69z1lkl441rc29n6mwncpkjj"; })
      (plugin { url = "https://github.com/jose-elias-alvarez/null-ls.nvim"; rev = "0adceda"; sha256 = "sha256-BEl1+f9kS8jnQLuTUropyC2/5Gl1gvepx4XaXontn9k="; })
      (plugin { url = "https://github.com/lervag/wiki.vim"; rev = "d3bc1ee"; sha256 = "sha256-hdE4UatZ/ocK2ks8k6XY8Mry/uoE+6mK5hPzWMD1UKU="; })
      (plugin { url = "https://github.com/nvim-treesitter/nvim-treesitter"; rev = "bb33aea"; sha256 = "sha256-UcuZZNJmWSVfeLAUJ3q+NObDS/rGkXbBCdXcdMBBYXg="; })
      (plugin { url = "https://github.com/Olical/aniseed"; rev = "7968693"; sha256 = "sha256-BMwTcwGEEB/n9AXgN1j/KpD1/ECrLjhHxRNOk02KXkk="; })
      (plugin { url = "https://github.com/Olical/conjure"; rev = "93a6685"; sha256 = "sha256-9j010dRHl8QBJ1oT9iQzeBvJx6mzRJbF8KPvwioPvKg="; })
      (plugin { url = "https://github.com/Olical/nvim-local-fennel"; rev = "5770299"; sha256 = "sha256-+dGoOXgp67tI8w0aVMcTrAgaLBh0a30csSZVWCz2xRg="; })
      (plugin { url = "https://github.com/onsails/lspkind-nvim"; rev = "f0d1552"; sha256 = "sha256-oAA4Q4FC+7fbBw8CwGrqP05PD+q5035vurYzMQLk03I="; })
      (plugin { url = "https://github.com/scr1pt0r/crease.vim"; rev = "b2e5b43"; sha256 = "1yg0p58ajd9xf00sr1y9sjy3nxim8af96svrcsy4yn7xbwk24xgm"; })
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
