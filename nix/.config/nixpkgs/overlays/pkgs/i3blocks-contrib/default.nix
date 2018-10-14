{
  acpi,
  alsaUtils,
  docker,
  fetchFromGitHub,
  iw,
  kbdd,
  lm_sensors,
  makeWrapper,
  mpv,
  perl,
  perlPackages,
  pulseaudio,
  python3,
  stdenv,
  sysstat,
  xclip,
  youtube-dl,
}:

with stdenv.lib;
with perlPackages;

let

  version = "e1ebfb23304e44c892b372aa96562e5b721dbbe1";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks-contrib";
    rev = version;
    sha256 = "16j8xrn4rmrixil70z8ihkzxaqvy46n0ig5r3vk9i3dmxzr8kw22";
  };

  output="$out/libexec/i3blocks";

  # function to install script block, patched with requirements
  scriptBlock = name: required:
    stdenv.mkDerivation {
      inherit name;
      inherit version;
      inherit src;

      postUnpack = "sourceRoot=\${sourceRoot}/${name}";

      nativeBuildInputs = [ makeWrapper ];

      buildPhase = ''
        mkdir -p ${output}
      '';

      installPhase = ''
        cp ${name} ${output}
        wrapProgram ${output}/${name} \
         --prefix PATH : "${makeBinPath required.bin}" \
         --set PERL5LIB "${makePerlPath required.perlDeps}"
      '';
    };

  # function to build script block requirements,
  # useful to avoid passing empty attributes
  required = args: ({
    bin = [];
    perlDeps = [];
  } // args);


  # function to install block that requires building
  makeBlock = name:
    stdenv.mkDerivation {
      inherit name;
      inherit version;
      inherit src;

      postUnpack = "sourceRoot=\${sourceRoot}/${name}";

      installPhase = ''
        mkdir -p ${output}
        cp ${name} ${output}
      '';
    };
in
rec {
  bandwidth         = scriptBlock "bandwidth"         ( required {});
  bandwidth2        = makeBlock "bandwidth2";
  bandwidth3        = scriptBlock "bandwidth3"        ( required {});
  battery           = scriptBlock "battery"           ( required {bin = [acpi];});
  battery2          = scriptBlock "battery2"          ( required {bin = [acpi python3];});
  batterybar        = scriptBlock "batterybar"        ( required {bin = [acpi];});
  calendar          = scriptBlock "calendar"          ( required {bin = [xdotool yad];});
  cpu_usage         = scriptBlock "cpu_usage"         ( required {bin = [sysstat]; });
  disk              = scriptBlock "disk"              ( required {});
  disk-io           = scriptBlock "disk-io"           ( required {bin = [sysstat]; });
  docker            = scriptBlock "docker"            ( required {bin = [docker]; });
  essid             = scriptBlock "essid"             ( required {});
  kbdd_layout       = scriptBlock "kbdd_layout"       ( required {bin = [kbdd]; });
  memory            = scriptBlock "memory"            ( required {});
  openvpn           = scriptBlock "openvpn"           ( required {});
  temperature       = scriptBlock "temperature"       ( required {bin = [perl lm_sensors]; });
  time              = scriptBlock "time"              ( required {bin = [perl];});
  usb               = scriptBlock "usb"               ( required {bin = [python3];});
  volume            = scriptBlock "volume"            ( required {});
  volume-pulseaudio = scriptBlock "volume-pulseaudio" ( required {bin = [alsaUtils pulseaudio];});
  wifi              = scriptBlock "wifi"              ( required {});
  wlan-dbm          = scriptBlock "wlan-dbm"          ( required {bin = [iw]; });
  ytdl-mpv          = scriptBlock "ytdl-mpv"          ( required {bin = [mpv xclip youtube-dl perl]; perlDeps = [ DataValidateURI DataValidateDomain NetDomainTLD DataValidateIP NetAddrIP ]; });
}
