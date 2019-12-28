{ pkgs, ...}:
{
  # clojure uses jdk11
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/interpreters/clojure/default.nix
  home.packages = with pkgs; [
    jdk11
    (leiningen.override { jdk = jdk11; })
    clojure
  ];
}
