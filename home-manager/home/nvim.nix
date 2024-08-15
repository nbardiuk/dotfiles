{ pkgs, mypkgs, config, ... }:
{
  programs.neovim = {
    enable = true;
    package = mypkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
    extraLuaConfig = ''require("dotfiles")'';
    extraLuaPackages = ps: [
      ps.jsregexp # for luasnip
    ];
    plugins = with pkgs.vimPlugins; [
      cmp-buffer # buffer text source for nvim-cmp
      cmp-cmdline # command line source for nvim-cmp
      cmp-conjure # conjure source for nvim-cmp
      cmp-nvim-lsp # lsp source for nvim-cmp
      cmp-path # filesystem source for nvim-cmp
      cmp-spell # spelling source for nvim-cmp
      cmp-treesitter # tree sitter source for nvim-cmp
      cmp_luasnip # integrates luasnip with nvim-cmp
      dressing-nvim # vim.select and vim.input
      ferret
      fidget-nvim # lsp progress widget
      gitgutter
      lualine-nvim
      luasnip # snippets manager
      markdown-preview-nvim
      nvim-autopairs
      nvim-cmp # completion manager
      nvim-lspconfig
      nvim-metals
      nvim-surround
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.clojure
        p.comment
        p.css
        p.csv
        p.diff
        p.dockerfile
        p.fennel
        p.gitcommit
        p.gitignore
        p.groovy
        p.hocon
        p.html
        p.http
        p.java
        p.javascript
        p.jq
        p.json
        p.json5
        p.lua
        p.markdown
        p.markdown_inline
        p.nix
        p.python
        p.scala
        p.scss
        p.sql
        p.ssh_config
        p.typescript
        p.xml
        p.yaml
      ]))
      nvim-treesitter-context
      nvim-treesitter-textobjects
      nvim-web-devicons
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
      vim-easy-align
      vim-eunuch
      vim-fubitive # bitbucket for fugitive
      vim-fugitive
      vim-indent-object
      vim-matchup
      vim-repeat
      vim-rsi
      vim-sexp
      vim-sexp-mappings-for-regular-people
      vim-slime
      vim-unimpaired
      mypkgs.vimPlugins.colorizer
      mypkgs.vimPlugins.co-author
      mypkgs.vimPlugins.conform-nvim
      mypkgs.vimPlugins.conjure
      mypkgs.vimPlugins.nfnl
      mypkgs.vimPlugins.none-ls
      mypkgs.vimPlugins.nvim-grey
      mypkgs.vimPlugins.other-nvim
      mypkgs.vimPlugins.tsc-nvim
      mypkgs.vimPlugins.vim-rest-console
      mypkgs.vimPlugins.wiki-vim
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
    shfmt # shell scripts formatter
    xsel # clipboard manager
    jq # json formatter
    libxml2 # for xmllint
    yamlfmt # yaml formatter
    pgformatter # sql formatter
    sqlint # sql linter
    ccls
    clang-tools
    hadolint # dockerfile linter
    fennel
    pandoc # for markdown conversion
    codespell
    sqls
    tree-sitter
    fennel-ls
    fnlfmt
    nixd # nix language server
  ];
}
