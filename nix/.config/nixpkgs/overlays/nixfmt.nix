final: previous:
let
  url = "https://github.com/serokell/nixfmt/archive/v0.2.0.tar.gz";
  nixfmt = import (builtins.fetchTarball url) { };
in { inherit nixfmt; }
