{ fetchFromGitHub, stdenv, autoreconfHook}:

stdenv.mkDerivation rec {

  name = "i3blocks-${version}";
  version = "git";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks";
    rev = "37f23805ff886639163fbef8aedba71c8071eff8";
    sha256 = "15rnrcajzyrmhlz1a21qqsjlj3dkib70806dlb386fliylc2kisb";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "A minimalist scheduler for your status line scripts";
    homepage = https://github.com/vivien/i3blocks;
    license = licenses.gpl3;
    platforms = with platforms; freebsd ++ linux;
  };
}
