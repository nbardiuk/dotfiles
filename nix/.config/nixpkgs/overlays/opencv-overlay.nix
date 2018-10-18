final: previous:
let

  opencv = previous.opencv3.override {
    enableContrib = true;
  };

  opencv3-java = opencv.overrideAttrs( origAttrs: rec {
    name = "${origAttrs.name}-java";
    cmakeFlags = origAttrs.cmakeFlags ++ [
      "-DBUILD_opencv_dnn=OFF" # fails to build
      "-DBUILD_SHARED_LIBS=OFF"
    ];
    buildInputs = origAttrs.buildInputs ++ [ final.ant ];
    propagatedBuildInputs = origAttrs.propagatedBuildInputs ++
      [ final.jdk final.python3Full ];
  });

in {
  inherit opencv3-java;
}
