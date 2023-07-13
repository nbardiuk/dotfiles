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
    package = neovim-nightly "3933bf7c2b1bd571d68b1e487c63402baac35710";
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
    extraLuaConfig = ''
      require("nfnl").setup()
      require("dotfiles")
    '';
    plugins = with pkgs.vimPlugins; [
      cmp-buffer # buffer text source for nvim-cmp
      cmp-conjure # conjure source for nvim-cmp
      cmp-nvim-lsp # lsp source for nvim-cmp
      cmp-path # filesystem source for nvim-cmp
      cmp-spell # spelling source for nvim-cmp
      cmp-treesitter # tree sitter source for nvim-cmp
      cmp_luasnip # integrates luasnip with nvim-cmp
      comment-nvim
      dressing-nvim # vim.select and vim.input
      ferret
      fidget-nvim # lsp progress widget
      gitgutter
      lightspeed-nvim # quick jumps
      lspkind-nvim
      lualine-nvim
      luasnip # snippets manager
      markdown-preview-nvim
      null-ls-nvim # linters and formatters using lsp
      nvim-autopairs
      nvim-cmp # completion manager
      nvim-lspconfig
      nvim-surround
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      nvim-treesitter-textobjects
      oil-nvim # dired inspired browser
      playground # treesitter playground
      plenary-nvim # for telescope, and null-ls
      rhubarb # github provider for fugitive
      tabular
      targets-vim
      telescope-fzf-native-nvim
      telescope-nvim
      tmux-navigator
      undotree
      vim-abolish
      vim-cool # manages search highlight
      vim-dadbod
      vim-dadbod-completion
      vim-easy-align
      vim-eunuch
      vim-fugitive
      vim-indent-object
      vim-matchup
      vim-repeat
      vim-rsi
      vim-sexp
      vim-sexp-mappings-for-regular-people
      vim-slime
      vim-unimpaired
      (plugin {
        url = "https://github.com/2KAbhishek/co-author.nvim";
        rev = "b18ac50";
        sha256 = "sha256-8JOc6Y/p/nwMiu4ZCPV/WmgGkwB1VN45Hu+NHnt9jRc=";
      })
      (plugin {
        url = "https://github.com/chrisbra/colorizer";
        rev = "715c913";
        sha256 = "sha256-HnIDb6cQKCSuUoNXmw75z5sYxbj9Cv0xMVOWSCgU8jw=";
      })
      (plugin {
        url = "https://github.com/diepm/vim-rest-console";
        rev = "7b407f4";
        sha256 = "1x7qicd721vcb7zgaqzy5kgiqkyj69z1lkl441rc29n6mwncpkjj";
      })
      (plugin {
        url = "https://github.com/lervag/wiki.vim";
        rev = "6777c73";
        sha256 = "sha256-v203eAizjW82fAYIsUFa6EJFELH0QsPKXelLnbYhoPI=";
      })
      (plugin {
        url = "https://github.com/Olical/conjure";
        rev = "v4.46.0";
        sha256 = "sha256-700AhkKvc1X/Q/+YaLuDFlDzNKcd3kuXbMb9NIG7tMo=";
      })
      (plugin {
        url = "https://github.com/Olical/nfnl";
        rev = "bce853c";
        sha256 = "sha256-mtsZgXYXQdd08zGu/5bGvcOKrzf8POyFdagJxDhp+Lc=";
      })
      (plugin {
        url = "https://github.com/rgroli/other.nvim";
        rev = "9afecea";
        sha256 = "sha256-df/L8ZOdjkviE6WRRe7uon82hlUb+yYDdtiN3pJ5OBs=";
      })
      (plugin {
        url = "https://github.com/yorickpeterse/nvim-grey";
        rev = "70a5d2d";
        sha256 = "sha256-tn1HH2YoxMFbUQxVKoBCgC9wBq9DpB5PMaKm3DLgH20=";
      })
    ];
  };

  xdg.configFile = with config.lib.file; {
    "nvim/lua".source = mkOutOfStoreSymlink ./nvim/lua;
    "nvim/queries".source = mkOutOfStoreSymlink ./nvim/queries;
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
    python310Packages.python-lsp-server
    ccls
    clang-tools
    hadolint # dockerfile linter
    fennel
    pandoc # for markdown conversion
    statix # nix linter
    nodePackages.fixjson # json formatter
    codespell
    sqls
    tree-sitter
    fennel-ls
  ];
}
