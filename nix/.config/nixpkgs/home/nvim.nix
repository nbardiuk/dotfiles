{ pkgs, ... }:
let
  wiki-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/lervag/wiki.vim";
    pname = "wiki-vim";
    version = "2020-10-01";
    src = pkgs.fetchFromGitHub {
      owner = "lervag";
      repo = "wiki.vim";
      rev = "292d96e";
      sha256 = "1jp5z61n5k64khwwa3g7l3224bjiwgd6x3jqwmnk41x9vsk0g5l3";
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
  ncm2-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/ncm2/ncm2-vim";
    pname = "ncm2-vim";
    version = "2018-08-15";
    src = pkgs.fetchFromGitHub {
      owner = "ncm2";
      repo = "ncm2-vim";
      rev = "4ee5d3e8b5710890cb5da7875790bdd5a8b3ca07";
      sha256 = "0m4rs2bs0j74l7gqyzcdhprvvx2n7hw64bbls877av6kix4azr31";
    };
  };
  ncm2-syntax = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/ncm2/ncm2-syntax";
    pname = "ncm2-syntax";
    version = "2020-06-19";
    src = pkgs.fetchFromGitHub {
      owner = "ncm2";
      repo = "ncm2-syntax";
      rev = "d41d60b22175822c14f497378a05398e3eca2517";
      sha256 = "065sflxr6sp491ifvcf7bzvpn5c47qc0mr091v2p2k73lp9jx2s2";
    };
  };
  vim-iced-ncm2 = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/nbardiuk/vim-iced-ncm2";
    pname = "vim-iced-ncm2";
    version = "2020-01-04";
    src = pkgs.fetchFromGitHub {
      owner = "nbardiuk";
      repo = "vim-iced-ncm2";
      rev = "f3fa54f84c046d074a6d2f3d363a9478cca5010b";
      sha256 = "18q5k31qdkl8fb32w68l5d49c3yrcf621za2h3x68yw7p3hpqmqy";
    };
  };
  vim-iced = pkgs.vimUtils.buildVimPluginFrom2Nix rec{
    meta.homepage = "https://github.com/liquidz/vim-iced";
    pname = "vim-iced";
    version = "2.6.0";
    src = pkgs.fetchFromGitHub {
      owner = "liquidz";
      repo = "vim-iced";
      rev = version;
      sha256 = "0jc7gaabkha9pkslc6a1gpg0iingr7v8sq9va4kyxzaz26mya5br";
    };
    postInstall = ''
      install -Dt $out/bin $out/share/vim-plugins/vim-iced/bin/iced
    '';
  };
  vim-clojure = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/clojure-vim/clojure.vim";
    pname = "vim-clojure";
    version = "2020-09-29";
    src = pkgs.fetchFromGitHub {
      owner = "clojure-vim";
      repo = "clojure.vim";
      rev = "73b713f79d13d45b0c44d1292f5384ee16117f7d";
      sha256 = "0lj56acyik2dghrr5mqfkr7qnrixs5y2swvak9rl3jlwplg10ncr";
    };
  };
  mycolors = pkgs.vimUtils.buildVimPluginFrom2Nix {
    meta.homepage = "https://github.com/nbardiuk/vim-colors";
    pname = "vim-colors";
    version = "2020-05-30";
    src = pkgs.fetchFromGitHub {
      owner = "nbardiuk";
      repo = "vim-colors";
      rev = "7068cf3";
      sha256 = "10qlf15ani476fdwyaf11y2ddrdil4jizqi2i92bhad1mahb7sac";
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
    version = "2020-05-29";
    src = pkgs.fetchFromGitHub {
      owner = "chrisbra";
      repo = "colorizer";
      rev = "879e6c69c0c02c4ef0f08b3955c60de16efd8fb8";
      sha256 = "1wbmd9qyb4qsqdmd4dqnfi5jn44scv1pgacr56sy7dagx2iz5zj6";
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
    withPython = false;
    withPython3 = true;
    withRuby = false;
    configure = {
      customRC = (builtins.readFile ./init.vim);
      packages.myVimPackage.start = with pkgs.vimPlugins; [
        ale
        colorizer
        ferret
        float-preview-nvim # ncm2 preview
        fzf-vim
        fzfWrapper
        ghcid
        gitgutter
        goyo-vim
        LanguageClient-neovim
        mycolors
        ncm2
        ncm2-bufword
        ncm2-path
        ncm2-syntax # uses neco-syntax
        ncm2-tmux
        ncm2-vim # uses neco-vim
        neco-syntax # provides syntax completion function
        neco-vim # provides vim completion function
        neoformat
        nvim-yarp # remote plugin manager for ncm2
        rhubarb # github provider for fugitive
        tabular
        targets-vim
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
        vim-iced-ncm2
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
  };

  home.packages = with pkgs; [
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
