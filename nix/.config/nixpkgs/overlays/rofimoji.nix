final: previous:
let
rofimoji = with final; with stdenv; mkDerivation rec {

  name = "rofimoji-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    rev = version;
    sha256 = "17pwdc3jwqqx7qp1z6v9gsvwbrpyd1miz6nl2xqgw5p8851h5n79";
  };

  nativeBuildInputs = [makeWrapper];
  buildInputs = [python3 rofi xdotool];

  installPhase = ''
    mkdir -p $out
    cp rofimoji.py $out/rofimoji.py
    wrapProgram $out/rofimoji.py --prefix PATH : "${lib.makeBinPath buildInputs}"
  '';

  meta = with lib; {
    description = "A simple emoji picker for rofi";
    homepage = https://github.com/fdw/rofimoji;
    platforms = with platforms; freebsd ++ linux;
  };
};
in {
  inherit rofimoji;
}
