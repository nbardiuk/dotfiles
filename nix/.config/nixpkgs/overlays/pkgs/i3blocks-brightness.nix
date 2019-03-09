{ writeShellScriptBin }:

writeShellScriptBin "brightness" ''
    level=$(light | cut -d . -f 1)
    echo $level%

    case $BLOCK_BUTTON in
        3) light -S $((100 - $level)) ;;  # right click, invert brightness level
        4) light -A 5 ;;  # scroll up
        5) light -U 5 ;;  # scroll down
    esac
  ''
