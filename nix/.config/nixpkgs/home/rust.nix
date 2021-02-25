{ pkgs, ...}:
let
  enable = true;
  rls = pkgs.runCommandNoCC "${pkgs.rls.pname}-${pkgs.rls.version}" {
          inherit (pkgs.rls) src meta pname version;
          nativeBuildInputs = [ pkgs.makeWrapper ];
        } ''
          mkdir -p $out/bin
          makeWrapper ${pkgs.rls}/bin/rls $out/bin/rls \
            --set-default RUST_SRC_PATH "${pkgs.rustPlatform.rustcSrc}"
        '';
in if !enable then {} else {
  home.packages = with pkgs; [
    gcc
    cargo
    cargo-watch
    clippy
    rls
    rustfmt
  ];
}
