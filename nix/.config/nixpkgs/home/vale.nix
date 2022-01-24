{ pkgs, ... }:
let
  writeGood = pkgs.fetchFromGitHub {
    owner = "errata-ai";
    repo = "write-good";
    rev = "2d11661";
    sha256 = "sha256-A0vuV4BdumbCb14wxiH5Sc9S75Yx8xwQqWzpfi43+ls=";
  };
  proseLint = pkgs.fetchFromGitHub {
    owner = "errata-ai";
    repo = "proselint";
    rev = "f9cc800";
    sha256 = "sha256-zOSQ7tvZH8v0nS5E8YhvZhA4L+GvkdMugM+eXqJbaxU=";
  };
  google = pkgs.fetchFromGitHub {
    owner = "errata-ai";
    repo = "Google";
    rev = "9d31bf7";
    sha256 = "sha256-qW5vvD8LCsBia/0cL0LY4g1WGx2pQIUWuqhVPDdTkjw=";
  };
  microsoft = pkgs.fetchFromGitHub {
    owner = "errata-ai";
    repo = "Microsoft";
    rev = "b48a0e3";
    sha256 = "sha256-WArPh87I6aWPdt90SCveG32EPuEaYlr1CGuFzUUQD3M=";
  };
  valeStyles = pkgs.stdenv.mkDerivation {
    name = "vale-styles";
    buildCommand = ''
      mkdir -p $out/styles
      cp -r ${writeGood}/write-good $out/styles
      cp -r ${proseLint}/proselint $out/styles
      cp -r ${google}/Google $out/styles
      cp -r ${microsoft}/Microsoft $out/styles
    '';
  };
in
{
  home.file.".vale.ini".text = ''
    StylesPath = ${valeStyles}/styles

    [*]
    BasedOnStyles = write-good, proselint, Google, Microsoft
  '';

  home.packages = with pkgs; [
    vale
  ];
}
