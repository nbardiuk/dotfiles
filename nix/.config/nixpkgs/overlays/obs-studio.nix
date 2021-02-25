final: previous:
let
  scriptingSupport = true;
  alsaSupport = true;
  pulseaudioSupport = true;
  obs-studio = with final; with final.pkgs; with pkgs.qt5; with pkgs.xorg; let
    inherit (lib) optional optionals;
  in
    mkDerivation rec {
      pname = "obs-studio";
      version = "25.0.8";

      src = fetchFromGitHub {
        owner = "obsproject";
        repo = "obs-studio";
        rev = version;
        sha256 = "0j2k65q3wfyfxhvkl6icz4qy0s3kfqhksizy2i3ah7yml266axbj";
      };

      nativeBuildInputs = [ addOpenGLRunpath cmake pkgconfig ];

      buildInputs = [
        curl
        fdk_aac
        ffmpeg
        jansson
        libjack2
        libv4l
        libxkbcommon
        libpthreadstubs
        libXdmcp
        qtbase
        qtx11extras
        qtsvg
        speex
        x264
        vlc
        makeWrapper
        mbedtls
      ]
      ++ optionals scriptingSupport [ luajit swig python3 ]
      ++ optional alsaSupport alsaLib
      ++ optional pulseaudioSupport libpulseaudio;

      # obs attempts to dlopen libobs-opengl, it fails unless we make sure
      # DL_OPENGL is an explicit path. Not sure if there's a better way
      # to handle this.
      cmakeFlags = [
        "-DCMAKE_CXX_FLAGS=-DDL_OPENGL=\\\"$(out)/lib/libobs-opengl.so\\\""
        "-DOBS_VERSION_OVERRIDE=${version}"
        "-Wno-dev" # kill dev warnings that are useless for packaging
      ];

      postInstall = ''
        wrapProgram $out/bin/obs \
          --prefix "LD_LIBRARY_PATH" : "${xorg.libX11.out}/lib:${vlc}/lib"
      '';

      postFixup = lib.optionalString stdenv.isLinux ''
        addOpenGLRunpath $out/lib/lib*.so
        addOpenGLRunpath $out/lib/obs-plugins/*.so
      '';

      meta = with lib; {
        description = "Free and open source software for video recording and live streaming";
        longDescription = ''
          This project is a rewrite of what was formerly known as "Open Broadcaster
          Software", software originally designed for recording and streaming live
          video content, efficiently
        '';
        homepage = "https://obsproject.com";
        maintainers = with maintainers; [ jb55 MP2E ];
        license = licenses.gpl2;
        platforms = [ "x86_64-linux" "i686-linux" ];
      };
    };
in
{
  inherit obs-studio;
}
