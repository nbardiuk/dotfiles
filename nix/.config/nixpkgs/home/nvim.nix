{ pkgs, config, ... }:
let
   conjure = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    meta.homepage = "https://github.com/Olical/conjure";
    pname = "conjure";
    version = "31820e3";
    src = pkgs.fetchFromGitHub {
      owner = "Olical";
      repo = pname;
      rev = version;
      sha256 = "sha256:1p35blgnd99kggwyiag6drx3v6zqx50ypxnfvvij102ws50144fk";
    };
  };
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
    version = "2021-05-19";
    src = pkgs.fetchFromGitHub {
      owner = "lervag";
      repo = "wiki.vim";
      rev = "caaaea0";
      sha256 = "0l0x5nn3br7g93j1z9d6cgg0svl4vgdwmd4j4ya563hmkvn4a1s3";
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
  mycolors = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/nbardiuk/vim-colors";
    pname = "vim-colors";
    version = "2021-04-14";
    src = pkgs.fetchFromGitHub {
      owner = "nbardiuk";
      repo = "vim-colors";
      rev = "930e022";
      sha256 = "12z1rlwcgmsdp8zhsf5qqbr5hfdyccylqssg76svj86d5a92fswd";
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
  # workaround for overlay cycle https://github.com/nix-community/neovim-nightly-overlay/issues/111
  neovim-nightly = (import <nixpkgs> {
    overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/neovim-nightly-overlay/archive/b40ca8a.tar.gz;
      }))
    ];
  }).neovim-nightly;
in
{
  programs.neovim = {
    package = neovim-nightly;
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
      colorizer
      compe-conjure
      conjure
      ferret
      fzf-vim
      fzfWrapper
      ghcid
      gitgutter
      hop-nvim
      lispdocs-nvim # clojure docs for conjure
      mycolors
      nvim-compe
      nvim-lspconfig
      plenary-nvim # for telescope
      popup-nvim # for telescope
      rhubarb # github provider for fugitive
      sql-nvim # for lispdocs-nvim
      tabular
      targets-vim
      telescope-nvim
      tmux-navigator
      vim-abolish
      vim-commentary
      vim-cool # manages search highlight
      vim-crease
      vim-eunuch
      vim-fugitive
      vim-gol
      vim-indent-object
      vim-markdown
      vim-matchup
      vim-projectionist
      vim-repeat
      vim-rest-console
      vim-rsi
      vim-sexp
      vim-sexp-mappings-for-regular-people
      vim-slime
      vim-surround
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
    python37Packages.python-language-server
    ccls
    clang-tools
    cljfmt
  ];
}
