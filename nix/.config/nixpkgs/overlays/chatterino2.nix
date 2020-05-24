final: previous:
let
  chatterino2 = with final; with final.pkgs; with pkgs.qt5; mkDerivation rec {
    pname = "chatterino2";
    version = "unstable-2020-01-16";
    src = fetchFromGitHub {
      owner = "chatterino";
      repo = pname;
      rev = "476825dc35c34e72729d07fa5661c53fd9db60d8";
      sha256 = "12cxmkb833njnl0wxrnf9yqbsgvqrwfb4k8pfji8j7hjidijhqh6";
      fetchSubmodules = true;
    };
    nativeBuildInputs = [ qmake pkgconfig wrapQtAppsHook ];
    buildInputs = [ qtbase qtsvg qtmultimedia boost openssl ];
    meta = with stdenv.lib; {
      description = "A chat client for Twitch chat";
      longDescription = ''
        Chatterino is a chat client for Twitch chat. It aims to be an
        improved/extended version of the Twitch web chat. Chatterino 2 is
        the second installment of the Twitch chat client series
        "Chatterino".
      '';
      homepage = "https://github.com/chatterino/chatterino2";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };
in
{
  inherit chatterino2;
}
