{ pkgs, config, lib, ... }:
let
  plugin = { url, rev, sha256 }:
    pkgs.vimUtils.buildVimPlugin {
      pname = with lib; (last (splitString "/" url));
      version = rev;
      src = pkgs.fetchgit { inherit url rev sha256; };
    };
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
    extraLuaConfig = ''require("dotfiles")'';
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
      lspkind-nvim
      lualine-nvim
      luasnip # snippets manager
      markdown-preview-nvim
      nvim-autopairs
      nvim-cmp # completion manager
      nvim-lspconfig
      nvim-surround
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      nvim-treesitter-textobjects
      oil-nvim # dired inspired browser
      playground # treesitter playground
      plenary-nvim # for telescope, and none-ls
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
        url = "https://github.com/nvimtools/none-ls.nvim";
        rev = "f1c0066";
        sha256 = "sha256-+6wmr6eWNs/vuKzm0j+ud3SVE38IKILzyhC/Y1AU9Qc=";
      })
      (plugin {
        url = "https://github.com/2KAbhishek/co-author.nvim";
        rev = "8e42c7c";
        sha256 = "sha256-IQeKO9U7qZM3+zt8vADRGec+1XXXy/4PsnFKf0GEKAU=";
      })
      (plugin {
        url = "https://github.com/chrisbra/colorizer";
        rev = "d4c0ed6";
        sha256 = "sha256-d0XiH8nNnO2+Xnk4ceehPvo+nvW5gn0e7XnYRPysXEk=";
      })
      (plugin {
        url = "https://github.com/diepm/vim-rest-console";
        rev = "7b407f4";
        sha256 = "1x7qicd721vcb7zgaqzy5kgiqkyj69z1lkl441rc29n6mwncpkjj";
      })
      (plugin {
        url = "https://github.com/lervag/wiki.vim";
        rev = "65b67f3";
        sha256 = "sha256-aGHFtVIO/BtGNnovmnmgU41rsez+JGz016pV/MScy8g=";
      })
      (plugin {
        url = "https://github.com/Olical/conjure";
        rev = "v4.49.0";
        sha256 = "sha256-KnYTkZEmCY4urXh4NaWGAip+dR5NMgj8rdyK6YzUmPo=";
      })
      (plugin {
        url = "https://github.com/Olical/nfnl";
        rev = "eaeef33";
        sha256 = "sha256-iJ/m7jH/62FaH0ZBhvZDA6RYBTLQIPAag1ka8WCsreo=";
      })
      (plugin {
        url = "https://github.com/rgroli/other.nvim";
        rev = "d4d926d";
        sha256 = "sha256-IeDj3Eecpm+LwXny6sLrurG/78MtgDvWk+TcMrYGGt8=";
      })
      (plugin {
        url = "https://github.com/yorickpeterse/nvim-grey";
        rev = "16d2036e6db3b3eef0cc141b24905575e6d67723";
        sha256 = "sha256-mDraHW26pNlMXjgA8ORXKLNSrV4BCb9IUIGLxRnYUdY=";
      })
      (plugin {
        url = "https://github.com/dmmulroy/tsc.nvim";
        rev = "a8f26d3";
        sha256 = "sha256-GerEK+eEi8y3shDNqGg14Oh6MPtKgasvfBxDuXGRyyA=";
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
    java-language-server
    eslint_d
    nil
  ];
}
