final: previous:
with final;
let
  pname = "beekeeper-studio";
  version = "3.9.14";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/Beekeeper-Studio-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    sha512 = "sha512-EzOF2gIMImPUYwF6Ayi1LVcRoMoM+bqhPUm66FSsBQLvRC/v2R+NhklY3pS6OJfOkvs2abkjb05gG45kYRBiSQ==";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in
{
  beekeeper-studio = appimageTools.wrapType2 {
    inherit name src;

    multiPkgs = null; # no 32bit needed
    extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ pkgs.bash ];

    extraInstallCommands = ''
          ln -s $out/bin/${name} $out/bin/${pname}
      install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
          install -m 444 -D ${appimageContents}/${pname}.png \
          $out/share/icons/hicolor/512x512/apps/${pname}.png
          substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

    meta = with lib; {
      description = "Modern and easy to use SQL client for MySQL, Postgres, SQLite, SQL Server, and more. Linux, MacOS, and Windows";
      homepage = "https://www.beekeeperstudio.io";
      changelog = "https://github.com/beekeeper-studio/beekeeper-studio/releases/tag/v${version}";
      license = licenses.mit;
      maintainers = with maintainers; [ milogert alexnortung ];
      platforms = [ "x86_64-linux" ];
    };
  };
}
