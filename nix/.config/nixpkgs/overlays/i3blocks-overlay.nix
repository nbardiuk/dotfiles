final: previous:
with final;
{
  i3blocks = callPackage ./pkgs/i3blocks-git {};
  i3blocks-contrib = callPackage ./pkgs/i3blocks-contrib {};
  i3blocks-brightness = callPackage ./pkgs/i3blocks-brightness.nix {};
}
