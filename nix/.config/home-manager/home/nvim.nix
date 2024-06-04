{ pkgs, config, inputs, ... }:
let
  plugin = src: pname: pkgs.vimUtils.buildVimPlugin { inherit src pname; version = src.rev; };
in
{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
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
      (plugin inputs.chrisbra-colorizer "colorizer")
      (plugin inputs.co-author "co-author")
      (plugin inputs.conjure "conjure")
      (plugin inputs.nfnl "nfnl")
      (plugin inputs.none-ls "none-ls")
      (plugin inputs.nvim-grey "nvim-grey")
      (plugin inputs.other-nvim "other-nvim")
      (plugin inputs.tsc-nvim "tsc-nvim")
      (plugin inputs.vim-rest-console "vim-rest-console")
      (plugin inputs.wiki-vim "wiki-vim")
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
