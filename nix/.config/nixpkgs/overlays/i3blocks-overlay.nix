final: previous:
{
  i3blocks = previous.callPackage ./pkgs/i3blocks-git {};
  i3blocks-contrib = previous.callPackage ./pkgs/i3blocks-contrib {};
  i3blocks-brightness = previous.callPackage ./pkgs/i3blocks-brightness.nix {};
}
