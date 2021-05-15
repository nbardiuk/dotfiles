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

  # like clojure-lsp hacks jars separately from native image
  # https://github.com/NixOS/nixpkgs/commit/2c3ad4ef9c5715fd5b74b4a664b54f5ab8ac7a2c
  deps = previous.stdenv.mkDerivation rec {
    name = "${pname}-${version}-deps";

    inherit src;

    nativeBuildInputs = with final.pkgs; [
      (leiningen.override { jdk = jdk11; })
    ];

    postPatch = ''
      cd cljfmt

      substituteInPlace project.clj \
        --replace ":native-image" ":local-repo \"$out\" :native-image"

      export LEIN_HOME="$TMP"
    '';

    buildPhase = ''
      runHook preBuild

      lein with-profile +dev do deps, uberjar

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete
      runHook postInstall
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256:1xa8g5gl16cip0bj3bjvak133254wj1fdhd05rh6qa84w48anqsm";
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
        --replace ":native-image" ":local-repo \"${deps}\" :native-image"

      substituteInPlace project.clj \
        --replace "\"--verbose\"" "\"--verbose\" \"-H:-CheckToolchain\""

      export LEIN_HOME="$TMP"
      export LEIN_OFFLINE=true
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
