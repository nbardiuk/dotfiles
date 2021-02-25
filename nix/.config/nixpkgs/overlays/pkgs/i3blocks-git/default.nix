{ fetchFromGitHub, lib, stdenv, autoreconfHook}:

stdenv.mkDerivation rec {

  name = "i3blocks-${version}";
  version = "git";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks";
    rev = "ec050e79ad8489a6f8deb37d4c20ab10729c25c3";
    sha256 = "1fx4230lmqa5rpzph68dwnpcjfaaqv5gfkradcr85hd1z8d1qp1b";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "A minimalist scheduler for your status line scripts";
    homepage = https://github.com/vivien/i3blocks;
    license = licenses.gpl3;
    platforms = with platforms; freebsd ++ linux;
  };
}
