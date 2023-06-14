{ config, pkgs, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.memtest86.enable = false;

  hardware.cpu.intel.updateMicrocode = true;

  # Graphics
  hardware.nvidia.prime.sync.enable = true;
  hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.dpi = 96;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true; # enables opengl for 32bit apps
  hardware.opengl.setLdLibraryPath = true; # adds /run/opengl-driver/lib to LD_LIBRARY_PATH

  programs.steam.enable = false;

  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true; # fixes https://github.com/rycee/home-manager/pull/436#issuecomment-449755377

  networking.hostName = "bardiuk";
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.firewall.allowedTCPPorts = [ 5900 ];

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
    deviceUri = "hp:/net/ENVY_5640_series?ip=192.168.1.72";
    model = "drv:///hp/hpcups.drv/hp-envy_5640_series.ppd";
    ppdOptions.PageSize = "A4";
  }];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  sound.enable = true;
  sound.mediaKeys.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  environment.etc = {
    "pipewire/pipewire.conf.d/99-cofigs.conf".text = builtins.toJSON {
      "context.properties" = {
        "link.max-buffers" = 16;
        "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 358000 384000 716000 768000 ];
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 8192;
      };
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true; # for blueman applet https://github.com/rycee/home-manager/blob/6aa44d62ad6526177a8c1f1babe1646c06738614/modules/services/blueman-applet.nix#L15

  services.xserver.enable = true;

  services.gnome.gnome-keyring.enable = true;

  # Keyboard
  services.xserver.layout = "us,ua";
  services.xserver.xkbOptions = "grp:win_space_toggle"; # man xkeyboard-config

  # Touchpad
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad = {
    naturalScrolling = true;
    clickMethod = "clickfinger";
    scrollMethod = "twofinger";
    additionalOptions = ''Option "TappingButtonMap" "lmr"'';
  };

  # Tablet
  services.xserver.wacom.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;

  virtualisation.virtualbox.host = {
    enable = false;
    addNetworkInterface = false;
    enableExtensionPack = false;
  };

  # Enable DE
  services.xserver.displayManager.sddm.enable = true;
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

  system.stateVersion = "21.11";

  nix = {
    settings.substituters = [ "https://cache.nixos.org/" ];
    settings.trusted-users = [ "root" "nazarii" ];
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.udisks2.enable = true;

  # tensorflow fail with default 10% of RAM
  services.logind.extraConfig = ''
    RuntimeDirectorySize=10G
  '';

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

  services.plex.enable = false;
  services.plex.user = "nazarii";
  services.plex.group = "users";
  services.plex.openFirewall = true;

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


  services.clamav.daemon.enable = false;
  services.clamav.updater.enable = false;
  system.autoUpgrade.enable = false;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
}
