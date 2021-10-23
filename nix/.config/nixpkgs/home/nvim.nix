{ pkgs, config, ... }:
let
  astronauta = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    meta.homepage = "https://github.com/tjdevries/astronauta.nvim";
    pname = "astronauta";
    version = "e69d7bd";
    src = pkgs.fetchFromGitHub {
      owner = "tjdevries";
      repo = "astronauta.nvim";
      rev = version;
      sha256 = "sha256:0dig863sdv1srhlwrn40g372if5hganhm1bh8qn3y39571gchqax";
    };
  };
  wiki-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/lervag/wiki.vim";
    pname = "wiki-vim";
    version = "2021-08-06";
    src = pkgs.fetchFromGitHub {
      owner = "lervag";
      repo = "wiki.vim";
      rev = "f8fb5b0";
      sha256 = "1md8xq8pmldp01nclcmdsw9hnqwyhh2qgplq8gsgg6ffz254lwkx";
    };
  };
  vim-rest-console = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/diepm/vim-rest-console";
    pname = "vim-rest-console";
    version = "2019-03-22";
    src = pkgs.fetchFromGitHub {
      owner = "diepm";
      repo = "vim-rest-console";
      rev = "7b407f4";
      sha256 = "1x7qicd721vcb7zgaqzy5kgiqkyj69z1lkl441rc29n6mwncpkjj";
    };
  };
  vim-colors = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    meta.homepage = "https://github.com/nbardiuk/vim-colors";
    pname = "vim-colors";
    version = "f8432d5";
    src = pkgs.fetchFromGitHub {
      owner = "nbardiuk";
      repo = "vim-colors";
      rev = version;
      sha256 = "12vsr3fdq7ri13bikw7djq8a87jfvn34dgbsrzmwa58ml7mwdk2h";
    };
  };
  vim-gol = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/nbardiuk/vim-gol";
    pname = "vim-gol";
    version = "2020-05-17";
    src = pkgs.fetchFromGitHub {
      owner = "nbardiuk";
      repo = "vim-gol";
      rev = "ec5314c";
      sha256 = "0bpm54857x6ls2kdjblf23lgskhychhcqvm5v39v62jr0il6pj4h";
    };
  };
  colorizer = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/chrisbra/colorizer";
    pname = "colorizer";
    version = "2021-01-15";
    src = pkgs.fetchFromGitHub {
      owner = "chrisbra";
      repo = "colorizer";
      rev = "826d569";
      sha256 = "069f8gqjihjzzv2qmpv3mid55vi52c6yyiijfarxpwmfchby9gc5";
    };
  };
  vim-crease = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/scr1pt0r/crease.vim";
    pname = "vim-crease";
    version = "2020-08-03";
    src = pkgs.fetchFromGitHub {
      owner = "scr1pt0r";
      repo = "crease.vim";
      rev = "b2e5b43b7faad17c0497ea5b6a4a9d732a227eb1";
      sha256 = "1yg0p58ajd9xf00sr1y9sjy3nxim8af96svrcsy4yn7xbwk24xgm";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = false;
    withPython3 = true;
    withRuby = false;
    extraConfig = (builtins.readFile ./init.vim);
    plugins = with pkgs.vimPlugins; [
      ale
      aniseed # fennel neovim configuration
      astronauta
      cmp-buffer # buffer text source for nvim-cmp
      cmp-conjure # conjure source for nvim-cmp
      cmp_luasnip # integrates luasnip with nvim-cmp
      cmp-nvim-lsp # lsp source for nvim-cmp
      cmp-nvim-lua # lua source for nvim-cmp
      cmp-path # filesystem source for nvim-cmp
      cmp-spell # spelling source for nvim-cmp
      colorizer
      conjure
      ferret
      fzf-vim
      fzfWrapper
      ghcid
      gitgutter
      hop-nvim
      lispdocs-nvim # clojure docs for conjure
      lspkind-nvim # decorate nvim-cmp
      luasnip # snippets manager
      nvim-cmp # completion mananger
      nvim-local-fennel
      nvim-lspconfig
      nvim-treesitter
      playground # treesitter playground
      plenary-nvim # for telescope
      popup-nvim # for telescope
      rhubarb # github provider for fugitive
      sql-nvim # for lispdocs-nvim
      tabular
      targets-vim
      telescope-nvim
      tmux-navigator
      undotree
      vim-abolish
      vim-colors
      vim-commentary
      vim-cool # manages search highlight
      vim-crease
      vim-eunuch
      vim-fugitive
      vim-gol
      vim-indent-object
      vim-markdown
      vim-matchup
      vim-nix
      vim-projectionist
      vim-repeat
      vim-rest-console
      vim-rsi
      vim-sexp
      vim-sexp-mappings-for-regular-people
      vim-slime
      vim-surround
      vim-terraform
      vim-unimpaired
      vim-vinegar
      wiki-vim
    ];
  };

  xdg.configFile = with config.lib.file; {
      "nvim/fnl/init.fnl".source = mkOutOfStoreSymlink ./init.fnl;
      "nvim/fnl/macros.fnl".source = mkOutOfStoreSymlink ./macros.fnl;
  };

  home.packages = with pkgs; [
    cachix     # to fetch nightly neovim
    nixpkgs-fmt               # nix formatter
    joker                     # clojure linter
    clj-kondo                 # clojure linter
    shellcheck                # shell scripts linter
    shfmt                     # shell scripts formatter
    vim-vint                  # vim linter
    xsel                      # clipboard manager
    jq                        # json formatter
    libxml2                   # for xmllint
    pgformatter               # sql formatter
    sqlint                    # sql linter
    python38Packages.python-lsp-server
    ccls
    clang-tools
    cljfmt
    hadolint                  # dockerfile linter
    nerdfonts
  ];
}
