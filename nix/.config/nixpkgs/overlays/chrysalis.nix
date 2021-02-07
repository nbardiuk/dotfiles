final: previus:
let
  pname = "Chrysalis";
  version = "0.8.3-snapshot";

  chrysalis = final.appimageTools.wrapType2 rec {
    name = "${pname}-${version}-binary";

    src = final.fetchurl {
      url = "https://github.com/keyboardio/${pname}/releases/download/v${version}/${pname}-${version}.AppImage";
      sha256 = "1ybcjy3ix4xa9iw922g17ld2q30ngi2b7jb7yrd0cfsnycab50yd";
    };

    multiPkgs = null;
    extraPkgs = p: (final.appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [
      p.glib
    ];

    extraInstallCommands = "mv $out/bin/${name} $out/bin/${pname}";

    meta = with final.lib; {
      description = "A graphical configurator for Kaleidoscope-powered keyboards";
      homepage = "https://github.com/keyboardio/Chrysalis";
      license = licenses.gpl3;
      maintainers = with maintainers; [ aw ];
      platforms = [ "x86_64-linux" ];
    };
  };

in
{
  inherit chrysalis;
}
