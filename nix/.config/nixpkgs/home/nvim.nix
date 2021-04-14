{ pkgs, ... }:
let
  wiki-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/lervag/wiki.vim";
    pname = "wiki-vim";
    version = "2021-03-09";
    src = pkgs.fetchFromGitHub {
      owner = "lervag";
      repo = "wiki.vim";
      rev = "749c5d5";
      sha256 = "1pkl7g3r6z00d267fh5mm0ks0cwi2brk2slsvw5h34p19pvws1m3";
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
  vim-iced = pkgs.vimUtils.buildVimPluginFrom2Nix rec{
    meta.homepage = "https://github.com/liquidz/vim-iced";
    pname = "vim-iced";
    version = "3.1.2";
    src = pkgs.fetchFromGitHub {
      owner = "liquidz";
      repo = "vim-iced";
      rev = version;
      sha256 = "05ynqsplb94l5374dcy1k8g9bi6c4cp4344062hwx4gsprqkk0j8";
    };
    postInstall = ''
      install -Dt $out/bin $out/share/vim-plugins/vim-iced/bin/iced
    '';
  };
  vim-clojure = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/clojure-vim/clojure.vim";
    pname = "vim-clojure";
    version = "2021-03-09";
    src = pkgs.fetchFromGitHub {
      owner = "clojure-vim";
      repo = "clojure.vim";
      rev = "fa110a4";
      sha256 = "04ngf6mx88syijvx4w6higkihz3npv8c92sgq1a73is5fnygm3rz";
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
  hop-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/phaazon/hop.nvim";
    pname = "hop-nvim";
    version = "2021-03-27";
    src = pkgs.fetchFromGitHub {
      owner = "phaazon";
      repo = "hop.nvim";
      rev = "07c9410";
      sha256 = "1m2bm4fmmfyr6cvrbzfa3vigf69nzhzkm73py3qjlbpr0d5la1s2";
    };
  };
  telescope-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/nvim-telescope/telescope.nvim";
    pname = "telescope-nvim";
    version = "2021-04-14";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope.nvim";
      rev = "07d5181";
      sha256 = "01xasjdcyxc4diyv7pz658qdhpwd1lv3q8j8bqczcn0d0l49w3yj";
    };
  };
  popup-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/nvim-lua/popup.nvim";
    pname = "popup-nvim";
    version = "2021-03-10";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-lua";
      repo = "popup.nvim";
      rev = "bc98ca6";
      sha256 = "0j1gkaba6z5vb922j47i7sq0d1zwkr5581w0nxd8c31klghg3kyn";
    };
  };
  plenary-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/nvim-lua/plenary.nvim";
    pname = "plenary-nvim";
    version = "2021-04-10";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "a3276a4";
      sha256 = "005xf3g9b38x6b29q9csbr2yyxvpw6f3nr6npygr65a2z4f1cjak";
    };
  };
  nvim-compe = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/hrsh7th/nvim-compe";
    pname = "nvim-compe";
    version = "2021-03-25";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-compe";
      rev = "a392842";
      sha256 = "0648gz8rc6l79hg3xqkr0049fn762v7rcyvq50ya81ljrs2jl004";
    };
  };
  nvim-lspconfig = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/neovim/nvim-lspconfig";
    pname = "nvim-lspconfig";
    version = "2021-03-21";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "nvim-lspconfig";
      rev = "97bdebe";
      sha256 = "1j7051cj4lim97kfpzhwgp95y63lk336yshbjsr89al9dxhvsaa3";
    };
  };
  conjure = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    meta.homepage = "https://github.com/Olical/conjure";
    pname = "conjure";
    version = "v4.16.0";
    src = pkgs.fetchFromGitHub {
      owner = "Olical";
      repo = "conjure";
      rev = version;
      sha256 = "0ifmv5n0mvvlasa56kr6bwnlm7p1y59kxmvpbdw42cp3az9mcrhj";
    };
  };
in
{
  programs.neovim = {
    package = pkgs.neovim-nightly;
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = false;
    withPython = false;
    withPython3 = true;
    withRuby = false;
    extraConfig = (builtins.readFile ./init.vim);
    plugins = with pkgs.vimPlugins; [
      ale
      colorizer
      conjure
      ferret
      fzf-vim
      fzfWrapper
      ghcid
      gitgutter
      hop-nvim
      mycolors
      nvim-compe
      nvim-lspconfig
      plenary-nvim # for telescope
      popup-nvim # for telescope
      rhubarb # github provider for fugitive
      tabular
      targets-vim
      telescope-nvim
      tmux-navigator
      vim-abolish
      vim-clojure
      vim-commentary
      vim-cool # manages search highlight
      vim-crease
      vim-dirvish # simple directory viewer
      vim-fugitive
      vim-gol
      vim-iced
      vim-indent-object
      vim-markdown
      vim-polyglot
      vim-projectionist
      vim-repeat
      vim-rest-console
      vim-rsi
      vim-sexp
      vim-sexp-mappings-for-regular-people
      vim-slime
      vim-surround
      vim-unimpaired
      wiki-vim
    ];
  };

  home.packages = with pkgs; [
    cachix     # to fetch nightly neovim
    nixpkgs-fmt               # nix formatter
    joker                     # clojure linter
    clj-kondo                 # clojure linter
    vim-iced                  # clojure nrepl
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
  ];
}
