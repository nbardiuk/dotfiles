{ self, inputs, pkgs, ... }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // { inherit self inputs; });
in
{
  dbeaver-ce = callPackage ../nix/.config/nixpkgs/overlays/dbeaver.nix { };
}
