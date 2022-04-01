{ config, pkgs, lib, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  # Decrypt partition before accessing LVM
  boot.initrd.luks.devices.root = {
    device = "/dev/sda2";
    preLVM = true;
  };

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
  hardware.pulseaudio.support32Bit = true;
  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true; # fixes https://github.com/rycee/home-manager/pull/436#issuecomment-449755377

  networking.hostName = "bardiuk";
  # networking.enableIPv6 = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.resolvconf.dnsExtensionMechanism = false;

  i18n.defaultLocale = "en_IE.UTF-8"; # English with correct date format
  time.timeZone = "Europe/Lisbon";

  environment.systemPackages = with pkgs; [
    vim
    pciutils
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.light.enable = true;
  programs.adb.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  hardware.printers.ensurePrinters = [{
    name = "hpenvy5640";
    deviceUri = "ipp://HPD639B4";
    model = "drv:///hp/hpcups.drv/hp-envy_5640_series.ppd";
    ppdOptions.PageSize = "A4";
  }];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.bluetooth.enable = true;
  # hardware.bluetooth.package = pkgs.bluez.override { enableMidi = true; };
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

  virtualisation.virtualbox.host = {
    enable = false;
    addNetworkInterface = false;
    enableExtensionPack = false;
  };

  # Enable DE
  services.xserver.displayManager.lightdm.greeters.mini = {
    enable = true;
    user = "nazarii";
    extraConfig = ''
      [greeter]
      show-password-label = false
      [greeter-theme]
      background-image = ""
    '';
  };
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

  system.stateVersion = "19.03";

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
    ];
    trustedUsers = [ "root" "nazarii" ];
  };

  services.acpid.enable = true;
  services.acpid.logEvents = true;

  services.sysstat.enable = true;

  services.plex.enable = false;
  services.plex.user = "nazarii";
  services.plex.group = "users";
  services.plex.openFirewall = true;

  services.udev.packages = with pkgs; [
    (writeTextFile {
      name = "kaleidoscope-udev-rules";
      destination = "/etc/udev/rules.d/60-kaleidoscope.rules";
      # https://github.com/keyboardio/Chrysalis/blob/master/static/udev/60-kaleidoscope.rules
      text = ''
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2300", SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2301", SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2302", SYMLINK+="Atreus2", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2303", SYMLINK+="Atreus2", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
      '';
    })
    (writeTextFile {
      name = "logitech-wheel-udev-rules";
      destination = "/etc/udev/rules.d/99-logitech-wheel.rules";
      text = ''
        # Logitech G29 Driving Force Racing Wheel
        SUBSYSTEMS=="hid", KERNELS=="0003:046D:C24F.????", DRIVERS=="logitech", SYMLINK+="logitech_g29", RUN+="${bash}/bin/sh -c 'chmod 666 %S%p/../../../range; chmod 777 %S%p/../../../leds/ %S%p/../../../leds/*; chmod 666 %S%p/../../../leds/*/brightness'"
      '';
    })
  ];
}
