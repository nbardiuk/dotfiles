{ pkgs, config, ... }:
let
  enable = true;
in
if !enable then { } else {

  xdg.configFile = with config.lib.file; {
    "ideavim/ideavimrc".source = mkOutOfStoreSymlink ./ideavimrc;
  };
}
