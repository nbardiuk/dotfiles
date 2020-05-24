{ pkgs, ... }:
let
  wiki-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "wiki-vim";
    version = "2020-02-06";
    src = pkgs.fetchFromGitHub {
      owner = "lervag";
      repo = "wiki.vim";
      rev = "a163aa74770346923e7e91520fef4d2936111559";
      sha256 = "0j4bxn1kmq5sgb5gg8qccckv9m4qp1fi549l9g2rnx2ybhrq1q4b";
    };
  };
  ncm2-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "ncm2-vim";
    version = "2018-08-15";
    src = pkgs.fetchFromGitHub {
      owner = "ncm2";
      repo = "ncm2-vim";
      rev = "4ee5d3e8b5710890cb5da7875790bdd5a8b3ca07";
      sha256 = "0m4rs2bs0j74l7gqyzcdhprvvx2n7hw64bbls877av6kix4azr31";
    };
  };
  ncm2-syntax = pkgs.vimUtils.buildVimPlugin {
    pname = "ncm2-syntax";
    version = "2018-12-11";
    src = pkgs.fetchFromGitHub {
      owner = "ncm2";
      repo = "ncm2-syntax";
      rev = "7cd3857001a219be4bc7593b7378034b462415e4";
      sha256 = "0l36qvsclhg8vr1ix1kpdl0kh739gp6b7s03f18vf9f0aj0im6w2";
    };
  };
  vim-iced-ncm2 = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-iced-ncm2";
    version = "2020-01-04";
    src = pkgs.fetchFromGitHub {
      owner = "nbardiuk";
      repo = "vim-iced-ncm2";
      rev = "f3fa54f84c046d074a6d2f3d363a9478cca5010b";
      sha256 = "18q5k31qdkl8fb32w68l5d49c3yrcf621za2h3x68yw7p3hpqmqy";
    };
  };
  vim-iced = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-iced";
    version = "2020-05-14";
    src = pkgs.fetchFromGitHub {
      owner = "liquidz";
      repo = "vim-iced";
      rev = "76cbe2c";
      sha256 = "0yb7bhnn4myw6s3rcxmn2g062lgrg5b5sfv3z1d5vg6hy0s9d5s1";
    };
    buildPhase = ":";
    postInstall=''
      install -Dt $out/bin $out/share/vim-plugins/vim-iced/bin/iced
    '';
  };
  vim-clojure-static = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-clojure-static";
    version = "2020-01-22";
    src = pkgs.fetchFromGitHub {
      owner = "nbardiuk";
      repo = "vim-clojure-static";
      rev = "29e5f2d";
      sha256 = "1cw1qzkl97l1ydggx7p0lik53r6yw1z26f2wqalz30y3ym7cpgfs";
    };
  };
  mycolors = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-colors";
    version = "2020-04-26";
    src = pkgs.fetchFromGitHub {
      owner = "nbardiuk";
      repo = "vim-colors";
      rev = "404869b";
      sha256 = "179cq2ccrfbamhs6yv6acb58pw76vdcq10wjg5ikkvhpldcafxpx";
    };
  };
  vim-gol = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-gol";
    version = "2020-05-17";
    src = pkgs.fetchFromGitHub {
      owner = "nbardiuk";
      repo = "vim-gol";
      rev = "ec5314c";
      sha256 = "0bpm54857x6ls2kdjblf23lgskhychhcqvm5v39v62jr0il6pj4h";
    };
  };
  colorizer = pkgs.vimUtils.buildVimPlugin {
    pname = "colorizer";
    version = "2020-05-03";
    src = pkgs.fetchFromGitHub {
      owner = "chrisbra";
      repo = "colorizer";
      rev = "61b652b";
      sha256 = "1nhplyissw6g38mpcc4jghdq6rcc1cmq5rmc58gkfvc12qzhrlvp";
    };
    buildPhase = ":";
  };
  loadPlugin = plugin: ''
    set rtp^=${plugin.rtp}
    set rtp+=${plugin.rtp}/after
  '';
  plugins = with pkgs.vimPlugins; [
    ale
    colorizer
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
    tmux-navigator
    vim-abolish
    vim-clojure-static
    vim-commentary
    vim-cool # manages search highlight
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
    vim-sexp
    vim-sexp-mappings-for-regular-people
    vim-surround
    vim-unimpaired
    vimux
    wiki-vim
  ];
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
    extraConfig = builtins.concatStringsSep "\n" [
      ''
        " Workaround for broken handling of packpath by vim8/neovim for ftplugins -- see https://github.com/NixOS/nixpkgs/issues/39364#issuecomment-425536054 for more info
        filetype off | syn off
        ${builtins.concatStringsSep "\n" (map loadPlugin plugins)}
        filetype indent plugin on | syn on
      ''
      (builtins.readFile ./init.vim)
    ];
  };

  home.packages = with pkgs; [
    nixpkgs-fmt               # nix formatter
    joker                     # clojure linter
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
