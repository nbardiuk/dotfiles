{ pkgs, ... }:
{

  services.keybase.enable = true;
  services.kbfs = {
    enable = true;
    mountPoint = "keybase";
  };

  home.packages = with pkgs; [
    keybase
    keybase-gui
  ];
}
