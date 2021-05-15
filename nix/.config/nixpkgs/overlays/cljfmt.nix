final: previous:
let
  pname = "cljfmt";
  version = "2021-04-30";

  src = previous.fetchFromGitHub {
    owner = "weavejester";
    repo = pname;
    rev = "8296f42d9840ab6adb6489dca1f3004154f2c2f3";
    sha256 = "19zi8k95ivgz516866w73yllycihpkb3hnbzaqlfbv4xqn6gi47b";
  };

  cljfmt = previous.stdenv.mkDerivation rec {
    name = "${pname}-${version}-binary";

    inherit src;

    nativeBuildInputs = with final.pkgs; [
      graalvm11-ce
      (leiningen.override { jdk = jdk11; })
    ];

    postPatch = ''
      cd cljfmt

      substituteInPlace project.clj \
        --replace ":native-image" ":local-repo \".m2\" :native-image"

      export LEIN_HOME="$TMP"
    '';

    buildPhase = ''
      runHook preBuild

      lein native-image

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 ./target/cljfmt $out/bin/cljfmt

      runHook postInstall
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256:0fnjimahxm3hs7ql4ma5mhwi4c3xl8lvl9bgkixi6c9cibwr1lc0";

    meta = with previous.lib; with final.pkgs; {
      description = "Code formatter for Clojure";
      homepage = "https://github.com/weavejester/cljfmt";
      license = licenses.mit;
      platforms = graalvm11-ce.meta.platforms;
    };
  };

in
{
  inherit cljfmt;
}
