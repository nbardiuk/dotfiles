final: previous:
with final;
with lib;
with perlPackages;

let

  version = "0d1cbe0";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks-contrib";
    rev = version;
    sha256 = "1n0b6sfz4p3hxvdy7spw7d3ggzkll3zds6v8v70xi5bf2jmwzy9s";
  };

  output = "$out/libexec/i3blocks";

  # function to install script block, patched with requirements
  scriptBlock = name: { bin ? [ ], perlDeps ? [ ] }:
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
        sed -i 's|#!/usr/bin/perl|#!/usr/bin/env perl |' ${output}/${name}
        wrapProgram ${output}/${name} \
         --prefix PATH : "${makeBinPath bin}" \
         --set PERL5LIB "${makePerlPath perlDeps}"
      '';
    };

  # function to install block that requires building
  makeBlock = name:
    stdenv.mkDerivation {
      inherit name;
      inherit version;
      inherit src;

      postUnpack = "sourceRoot=\${sourceRoot}/${name}";

      postPatch = ''
        sed -i "s/-Werror//g" Makefile
      '';

      installPhase = ''
        mkdir -p ${output}
        cp ${name} ${output}
      '';
    };
in
{
  i3blocks-contrib = {
    bandwidth2 = makeBlock "bandwidth2";
    battery2 = scriptBlock "battery2" { bin = [ acpi python3 ]; };
    cpu_usage = scriptBlock "cpu_usage" { bin = [ perl sysstat ]; };
    disk = scriptBlock "disk" { };
    kbdd_layout = scriptBlock "kbdd_layout" { bin = [ kbdd ]; };
    memory = scriptBlock "memory" { };
    temperature = scriptBlock "temperature" { bin = [ perl lm_sensors ]; };
    usb = scriptBlock "usb" { bin = [ python3 ]; };
    volume = scriptBlock "volume" { };
  };
}
