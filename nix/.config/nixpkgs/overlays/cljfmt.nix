final: previous:
let
  pname = "cljfmt";
  version = "0.8.0";

  src = previous.fetchFromGitHub {
    owner = "weavejester";
    repo = pname;
    rev = "3eccdf1";
    sha256 = "1fyjfjzfg6yv2ijghqddasn987m2bi9zd1dfxdxwiixxaczidv1x";
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

      substituteInPlace project.clj \
        --replace ":hooks [leiningen.cljsbuild]" ""

      export LEIN_HOME="$TMP"
    '';

    buildPhase = ''
      runHook preBuild

      lein deps

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
    outputHash = "1h3mqn6n6f5avzdz4p9r2c883s4y7pnz9040gl95kr0mz4n7l9g7";
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

      substituteInPlace project.clj \
        --replace ":hooks [leiningen.cljsbuild]" ""

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
