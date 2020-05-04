final: previous:
let
rofimoji = with final; python3Packages.buildPythonPackage rec {

  pname = "rofimoji-${version}";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    rev = version;
    sha256 = "0l0shfv3jvxrnhynrqqhp7flvd71c8yi57hqk00syzh960s8pw68";
  };

  nativeBuildInputs = [makeWrapper];
  propagatedBuildInputs = with python3Packages; [
    rofi
    xsel
    xdotool
    python3
    ConfigArgParse
    beautifulsoup4
    lxml
    pyxdg
    requests
  ];

  meta = with lib; {
    description = "A simple emoji picker for rofi";
    homepage = https://github.com/fdw/rofimoji;
    platforms = with platforms; freebsd ++ linux;
  };
};
in {
  inherit rofimoji;
}
