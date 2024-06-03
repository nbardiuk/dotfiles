final: previous:
with final;

let
  jre = temurin-jre-bin-17;
  rpath = lib.makeLibraryPath [
    fontconfig
    freetype
    glib
    glib-networking
    gtk3
    jre
    webkitgtk
    xorg.libX11
    xorg.libXrender
    xorg.libXtst
    zlib
  ] + ":${stdenv.cc.cc.lib}/lib64";
in
{
  dbeaver = stdenv.mkDerivation rec {
    name = "dbeaver";
    version = "24.0.0";
    src = fetchurl {
      url = "https://github.com/dbeaver/dbeaver/releases/download/${version}/dbeaver-ce_${version}_amd64.deb";
      sha256 = "sha256-9JG8f//XyYgsz8ICHpZdl5VgiAg7efNd1X0ZXS/ft2o=";
    };

    buildInputs = [ dpkg ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out
      dpkg -x $src $out

      cp -av $out/usr/* $out
      rm -rf $out/usr
      substituteInPlace $out/share/applications/dbeaver-ce.desktop --replace /usr/ $out/

      rm -rf $out/share/dbeaver-ce/jre
      mkdir -p $out/share/dbeaver-ce/jre
      cp -r ${jre}/* $out/share/dbeaver-ce/jre
    '';

    postFixup = ''
      for file in $(find $out -type f \( -perm /0111 -o -name \*.so\*  \) ); do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
        patchelf --set-rpath ${rpath}:$out/share/dbeaver-ce/dbeaver $file || true
      done
    '';
  };
}
