{ pkgs, config, ... }:
let
  passfile = "mpv/script-opts/webui.passwd";
in
{
  programs.mpv = {
    enable = false;
    config = rec {
      osd-font = "Iosevka";
      sub-font = "Iosevka";
      alang = "eng,ukr,pt-PT";
      slang = alang;
      vlang = alang;
      # save-position-on-quit = true; # https://mpv.io/manual/master/#options-save-position-on-quit
      # write-filename-in-watch-later-config = true; # https://mpv.io/manual/master/#options-write-filename-in-watch-later-config
    };
    scripts = with pkgs.mpvScripts; [
      # autoload # add neighbour files to playlist
      mpris # enable media keys
      simple-mpv-webui # web ui
      uosc # alternative interface
    ];
    scriptOpts = {
      webui = {
        port = 9876;
        logging = "yes";
        htpasswd_path = "${config.xdg.configHome}/${passfile}";
      };
    };
  };

  xdg.configFile."${passfile}".text = "nazarii:peeqOgZIzKRyHfmZeDKs";
}
