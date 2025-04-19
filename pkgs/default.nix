{ self, inputs, pkgs, ... }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // {
    inherit self inputs mypkgs;
  });

  writeBb = name: { content, deps ? [ ] }:
    (pkgs.writers.makeScriptWriter
      { interpreter = "${pkgs.babashka}/bin/bb"; }
      "/bin/${name}"
      content
    ).overrideAttrs (old: { buildInputs = deps; });

  plugin = src: pname: pkgs.vimUtils.buildVimPlugin { inherit src pname; version = src.rev; doCheck = false; };

  mypkgs = {
    connection_toggle = writeBb "connection-toggle" {
      content = ./connection-toggle.clj;
      deps = [ pkgs.rofi pkgs.networkmanager ];
    };

    keyboard_toggle = writeBb "keyboard-toggle" {
      content = ./keyboard-toggle.clj;
      deps = [ pkgs.rofi ];
    };

    open_book = writeBb "open-book" {
      content = ./open-book.clj;
      deps = [ pkgs.rofi pkgs.zathura ];
    };

    review-pr = writeBb "review-pr" { content = ./review-pr.clj; };

    vimPlugins = {
      colorizer = plugin inputs.chrisbra-colorizer "colorizer";
      co-author = plugin inputs.co-author "co-author";
      conform-nvim = plugin inputs.conform "conform-nvim";
      conjure = plugin inputs.conjure "conjure";
      nfnl = plugin inputs.nfnl "nfnl";
      none-ls = plugin inputs.none-ls "none-ls";
      nvim-grey = plugin inputs.nvim-grey "nvim-grey";
      other-nvim = plugin inputs.other-nvim "other-nvim";
      tsc-nvim = plugin inputs.tsc-nvim "tsc-nvim";
      vim-rest-console = plugin inputs.vim-rest-console "vim-rest-console";
      wiki-vim = plugin inputs.wiki-vim "wiki-vim";
    };

    neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

in
mypkgs
