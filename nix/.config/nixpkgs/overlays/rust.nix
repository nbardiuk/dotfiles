final: previous:
let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  moz_pkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
  base = moz_pkgs.latest.rustChannels.stable;
  rust = base.rust.override {
    extensions = [
      "clippy-preview"
      "rls-preview"
      "rust-analysis"
      "rust-src"
      "rust-std"
      "rustfmt-preview"
    ];
  };
  rust-src = base.rust-src;
  cargo = base.cargo;
  rustc = base.rustc;
in {
  rust_mozilla = rust;
}

