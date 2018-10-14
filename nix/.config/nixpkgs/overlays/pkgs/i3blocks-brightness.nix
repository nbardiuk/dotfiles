{ stdenv, xbacklight, writeShellScriptBin }:

with stdenv.lib;

let
  backlight = "${xbacklight}/bin/xbacklight";

  brightness = writeShellScriptBin "brightness" ''
    level=$(${backlight} | cut -d . -f 1)
    echo $level%

    case $BLOCK_BUTTON in
        3) ${backlight} -set $((100 - $level)) ;;  # right click, invert brightness level
        4) ${backlight} -inc 5 ;;  # scroll up
        5) ${backlight} -dec 5 ;;  # scroll down
    esac
  '';
in
  brightness
