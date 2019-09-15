{ pkgs, ... }:
let
  cachix = (import (fetchTarball "https://cachix.org/api/v1/install") { }).cachix;
  ghcide =   (import (fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master") {}).ghcide-ghc865;
in {
  home.packages = with pkgs; [
    cabal-install
    stack
    ghcide
    cachix
  ];
}
