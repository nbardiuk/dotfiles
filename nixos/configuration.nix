{ pkgs, lib, musnix, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-52a05dbc-e7d8-4389-b8c6-baad43856bcf".device = "/dev/disk/by-uuid/52a05dbc-e7d8-4389-b8c6-baad43856bcf";
  boot.initrd.luks.devices."luks-52a05dbc-e7d8-4389-b8c6-baad43856bcf".keyFile = "/crypto_keyfile.bin";

  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true; # fixes https://github.com/rycee/home-manager/pull/436#issuecomment-449755377

  networking.hostName = "bardiuk";
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.firewall.allowedTCPPorts = [
    # 9876 # mpv webui
    22000 # syncthing listener
  ];
  networking.firewall.allowedUDPPorts = [
    22000 # syncthing listener
    21027 # syncthing discovery
  ];

  # kde connect / valent
  # networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
  # networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];


  i18n.defaultLocale = "en_IE.UTF-8"; # English with EU date format
  time.timeZone = "Europe/Warsaw";

  environment.systemPackages = with pkgs; [
    vim
    pciutils
    linuxPackages.v4l2loopback # use obs as camera
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.light.enable = true;
  programs.adb.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  hardware.printers.ensurePrinters = [{
    name = "ENVY_5640";
    deviceUri = "hp:/net/ENVY_5640_series?ip=192.168.0.11";
    model = "drv:///hp/hpcups.drv/hp-envy_5640_series.ppd";
    ppdOptions.PageSize = "A4";
  }];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  sound.enable = true;
  sound.mediaKeys.enable = true;

  musnix.enable = true;
  musnix.soundcardPciId = "00:1f.3";
  musnix.rtirq.enable = true;
  musnix.rtcqs.enable = true;

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire =
    let
      quantum = 64;
      rate = 48000;
      qr = "${toString quantum}/${toString rate}";
    in
    {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = false;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire."99-lowlatency" = {
        context = {
          properties = {
            default = {
              clock.min-quantum = quantum;
            };
          };
        };
        modules = [
          {
            name = "libpipewire-module-rtkit";
            flags = [ "ifexists" "nofail" ];
            args = {
              nice.level = -15;
              rt = {
                prio = 88;
                time.soft = 200000;
                time.hard = 200000;
              };
            };
          }
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              server.address = [ "unix:native" ];
              pulse.min = {
                req = qr;
                quantum = qr;
                frag = qr;
              };
            };
          }
        ];
        stream.properties = {
          node.latency = qr;
          resample.quality = 1;
        };
      };
      wireplumber = {
        enable = true;
        configPackages =
          let
            # generate "matches" section of the rules
            matches = lib.generators.toLua
              {
                multiline = false; # looks better while inline
                indent = false;
              } [ [ [ "node.name" "matches" "alsa_output.*" ] ] ]; # nested lists are to produce `{{{ }}}` in the output

            # generate "apply_properties" section of the rules
            apply_properties = lib.generators.toLua { } {
              "audio.format" = "S32LE";
              "audio.rate" = rate * 2;
              "api.alsa.period-size" = 2;
            };
          in
          [
            (pkgs.writeTextDir "share/lowlatency.lua.d/99-alsa-lowlatency.lua" ''
              alsa_monitor.rules = {
                {
                  matches = ${matches};
                  apply_properties = ${apply_properties};
                }
              }
            '')
          ];
      };
    };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true; # for blueman applet https://github.com/rycee/home-manager/blob/6aa44d62ad6526177a8c1f1babe1646c06738614/modules/services/blueman-applet.nix#L15

  services.xserver.enable = true;
  services.xserver.dpi = 120; # 96 120 144 168 192 to avoid artifacts https://wiki.archlinux.org/title/Xorg#Setting_DPI_manually
  services.xserver.xrandrHeads = [
    {
      output = "DP-3";
      monitorConfig = ''
        DisplaySize 597 336
      '';
    }
    {
      output = "eDP-1";
      monitorConfig = ''
        DisplaySize 344 215
      '';
    }
  ];


  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = false; # enables opengl for 32bit apps
  hardware.opengl.setLdLibraryPath = false; # adds /run/opengl-driver/lib to LD_LIBRARY_PATH

  programs.steam.enable = false;

  services.gnome.gnome-keyring.enable = true;

  # Keyboard
  services.xserver.xkb = {
    layout = "us(altgr-intl),ua";
    options = "grp:win_space_toggle"; # man xkeyboard-config
  };

  # Touchpad
  services.libinput.enable = true;
  services.libinput.touchpad = {
    naturalScrolling = true;
    clickMethod = "clickfinger";
    scrollMethod = "twofinger";
    tappingButtonMap = "lmr"; #  1 left, 2 middle, 3 right
  };

  # Tablet
  services.xserver.wacom.enable = false;

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  virtualisation.virtualbox.host = {
    enable = false;
    addNetworkInterface = false;
    enableExtensionPack = false;
  };

  # Enable DE
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.enso.enable = true;
  services.xserver.desktopManager.xterm.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nazarii = {
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "vboxusers" "adbusers" "docker" ];
    group = "users";
    home = "/home/nazarii";
    isNormalUser = true;
    uid = 1000;
  };

  system.stateVersion = "23.05";

  nix = {
    settings.substituters = [ "https://cache.nixos.org/" ];
    settings.trusted-users = [ "root" "nazarii" ];
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.accept-flake-config = true;
    package = pkgs.nixFlakes;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  services.udisks2.enable = true;


  # https://github.com/vitejs/vite/issues/5310#issuecomment-949349291
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "nofile";
      value = "65536";
    }
  ];

  services.acpid.enable = true;
  services.acpid.logEvents = true;

  services.sysstat.enable = true;

  services.gvfs.enable = true; # Allows to see mtp devices in file manager

  hardware.new-lg4ff.enable = true; # Logitech G29 wheel drivers https://github.com/berarma/new-lg4ff
  services.udev.packages = with pkgs; [
    chrysalis # https://github.com/NixOS/nixpkgs/blob/fea4a1365abce59be3bbaa1a1ba5a990f116e014/pkgs/applications/misc/chrysalis/default.nix#L32
    (writeTextFile {
      name = "logitech-wheel-udev-rules";
      destination = "/etc/udev/rules.d/99-logitech-wheel.rules";
      text = ''
        # Logitech G29 Driving Force Racing Wheel
        SUBSYSTEMS=="hid", KERNELS=="0003:046D:C24F.????", DRIVERS=="logitech", SYMLINK+="logitech_g29", RUN+="${bash}/bin/sh -c 'chmod 666 %S%p/../../../range; chmod 777 %S%p/../../../leds/ %S%p/../../../leds/*; chmod 666 %S%p/../../../leds/*/brightness'"
      '';
    })
  ];


  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  services.jackett.enable = true;
}
