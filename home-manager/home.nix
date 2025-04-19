{ pkgs, mypkgs, ... }:
{
  imports = [
    ./home/alacritty.nix
    ./home/clojure.nix
    ./home/javascript.nix
    ./home/rust.nix
    ./home/haskell.nix
    ./home/i3.nix
    ./home/firefox.nix
    ./home/guile.nix
    ./home/java.nix
    ./home/keyboard.nix
    ./home/k9s.nix
    ./home/mpv.nix
    ./home/obs.nix
    ./home/psql.nix
    ./home/mysql.nix
    ./home/scala.nix
    ./home/shell.nix
    ./home/sqlite.nix
    ./home/syncthing.nix
    ./home/zathura.nix
    ./home/emacs.nix
  ];

  # How unread and relevant news should be presented
  # when running home-manager build and home-manager switch.
  # news.display = "silent";

  fonts.fontconfig.enable = true;

  programs.home-manager = {
    enable = true;
    path = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  };

  programs.command-not-found.enable = true;

  # always starts new services
  systemd.user.startServices = true;

  xdg.enable = true;


  services.easyeffects.enable = false;

  # The set of packages to appear in the user environment.
  home.packages = with pkgs; [
    chromium
    google-fonts # collection of fonts
    iosevka-bin # monospace font
    keepassxc # password manager
    libreoffice-fresh
    tdesktop # chat app
    # transmission_4-gtk
    qbittorrent
    # vscode-with-extensions

    # chatterino2
    # streamlink

    # blender
    # geeqie

    # lmms
    # ardour
    # qtractor
    # pianobooster
    musescore
    # solfege

    reaper # daw
    audacity
    ardour # daw
    # bitwig-studio
    transcribe
    yt-dlp

    # https://www.linuxsampler.org
    # linuxsampler
    # qsampler


    # webtorrent_desktop

    # yoshimi # synth
    # surge-XT # synth
    # fluidsynth # synth
    # rosegarden # midi seq
    # hydrogen # drum machine
    # lsp-plugins
    # fire
    # odin2
    # vital
    # decent-sampler
    # dragonfly-reverb


    helvum # pipewire patchbay


    # sysstat
    # flamegraph

    slack
    discord
    # element-desktop

    zoom-us

    protonvpn-gui

    # screenkey
    # slop

    kdePackages.kdenlive
    ffmpeg-full
    frei0r

    # josm
    # googleearth


    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/steam.nix
    # steam
    # steam.run

    # anki

    gimp
    krita
    darktable
    gthumb
    shotwell

    curtail # image compression
    imagemagick

    # video-trimmer

    calibre

    chrysalis

    zeal
    # plantuml
    # nodePackages.mermaid-cli

    # aws-vault
    # awscli2
    # ssm-session-manager-plugin
    # amazon-ecr-credential-helper

    # (google-cloud-sdk.withExtraComponents [
    #   google-cloud-sdk.components.cloud_sql_proxy
    #   google-cloud-sdk.components.gke-gcloud-auth-plugin
    #   google-cloud-sdk.components.kubectl
    # ])

    watchman

    # drawio

    xsane

    # beekeeper-studio
    dbeaver-bin

    nautilus
    flameshot

    lazydocker

    scrcpy # android control
    gnirehtet # android reverse tethering
    # libsForQt5.kdeconnect-kde # kde connect remote android

    v4l-utils # video4linux devices

    obsidian # notes

    betaflight-configurator
    usbutils
    xournalpp

    vlc

    guvcview # webcam config
    webcamoid # webcam recording
  ];

  home.stateVersion = "23.05";

  home.username = "nazarii";
  home.homeDirectory = "/home/nazarii";
}
