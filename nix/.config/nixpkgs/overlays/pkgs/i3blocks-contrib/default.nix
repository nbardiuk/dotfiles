{ fetchFromGitHub, stdenv, makeWrapper, lm_sensors, sysstat, acpi, kbdd}:

with stdenv.lib;

let
  output="$out/libexec/i3blocks";
in
stdenv.mkDerivation rec {

  name = "i3blocks-contrib-${version}";
  version = "git";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks-contrib";
    rev = "e1ebfb23304e44c892b372aa96562e5b721dbbe1";
    sha256 = "16j8xrn4rmrixil70z8ihkzxaqvy46n0ig5r3vk9i3dmxzr8kw22";
  };

  buildPhase = ''
    mkdir -p ${output}
  '';

  nativeBuildInputs = [ makeWrapper ];

  bandwidth2 = ''
    cd bandwidth2
    make
    cd ..
    cp bandwidth2/bandwidth2 ${output}
  '';

  battery = ''
    cp battery/battery ${output}
    wrapProgram ${output}/battery --prefix PATH : "${makeBinPath [acpi]}"
  '';

  cpu_usage = ''
    cp cpu_usage/cpu_usage ${output}
    wrapProgram ${output}/cpu_usage --prefix PATH : "${makeBinPath [sysstat]}"
  '';

  disk = ''
    cp disk/disk ${output}
  '';

  disk_io = ''
    cp disk-io/disk-io ${output}
  '';

  kbdd_layout = ''
    cp kbdd_layout/kbdd_layout ${output}
    wrapProgram ${output}/kbdd_layout --prefix PATH : "${makeBinPath [kbdd]}"
  '';

  memory = ''
    cp memory/memory ${output}
  '';

  openvpn = ''
    cp openvpn/openvpn ${output}
  '';

  temperature = ''
    cp temperature/temperature ${output}
    wrapProgram ${output}/temperature --prefix PATH : "${makeBinPath [lm_sensors]}"
  '';

  usb = ''
    cp usb/usb ${output}
  '';

  volume = ''
    cp volume/volume ${output}
  '';

  installPhase = strings.concatStrings [
    bandwidth2
    battery
    cpu_usage
    disk
    disk_io
    kbdd_layout
    memory
    openvpn
    temperature
    usb
    volume
  ];

  meta =  {
    description = "Community contributed blocklets for i3blocks";
    homepage = https://github.com/vivien/i3blocks-contrib;
    license = licenses.gpl3;
    platforms = with platforms; freebsd ++ linux;
  };
}
