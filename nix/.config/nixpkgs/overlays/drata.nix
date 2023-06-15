final: previous:
with final;

let
  rpath = lib.makeLibraryPath [
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    glibc
    libsecret
    libuuid

    gdk-pixbuf
    gtk3
    libappindicator-gtk3

    gnome.gnome-keyring

    libnotify
    libpulseaudio
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd

    libv4l
    libdrm
    mesa
    libxkbcommon
    # libxshmfence
    xorg.libxkbfile
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
    xorg.libxcb
  ] + ":${stdenv.cc.cc.lib}/lib64";
in

{
  drata-agent = stdenv.mkDerivation {
    name = "drata-agent";
    src = ./drata-agent-3.3.0.deb;

    buildInputs = [ dpkg ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out
      dpkg -x $src $out
      cp -av $out/usr/* $out
      rm -rf $out/usr
      mv $out/opt/Drata\ Agent $out/opt/drata-agent

      mkdir -p $out/bin
      ln -s "$out/opt/drata-agent/drata-agent" "$out/bin/drata-agent"
    '';

    postFixup = ''
      for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* -or -name \*.node\* \) ); do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
        patchelf --set-rpath ${rpath}:$out/opt/drata-agent $file || true
      done
      # Fix the desktop link
      substituteInPlace $out/share/applications/drata-agent.desktop \
        --replace /opt/Drata\ Agent $out/opt/drata-agent
    '';
  };
}
