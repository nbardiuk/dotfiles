{ config, pkgs, lib, ... }:
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
  hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";
  hardware.nvidia.modesetting.enable = true;
  services.xserver.dpi = 96;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # enables opengl for 32bit apps

  programs.steam.enable = true;

  hardware.xone.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true; # fixes https://github.com/rycee/home-manager/pull/436#issuecomment-449755377

  networking.hostName = "tvbox";
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.firewall.allowedTCPPorts = [
    8080 # qbittorent
  ];

  i18n.defaultLocale = "en_IE.UTF-8"; # English with EU date format
  time.timeZone = "Europe/Madrid";

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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true; # for blueman applet https://github.com/rycee/home-manager/blob/6aa44d62ad6526177a8c1f1babe1646c06738614/modules/services/blueman-applet.nix#L15

  services.xserver.enable = true;

  services.gnome.gnome-keyring.enable = true;

  # Keyboard
  services.xserver.xkb.layout = "us,ua";
  services.xserver.xkb.options = "grp:win_space_toggle"; # man xkeyboard-config

  # Touchpad
  services.libinput.enable = true;
  services.libinput.touchpad = {
    naturalScrolling = true;
    clickMethod = "clickfinger";
    scrollMethod = "twofinger";
    additionalOptions = ''Option "TappingButtonMap" "lmr"'';
  };

  # Enable DE
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.xterm.enable = true;
  # services.xserver.desktopManager.kodi.enable = true;

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

  services.logind.lidSwitchExternalPower = "ignore";

  services.upower.enable = true;

  services.thermald.enable = true;

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

  services.plex.enable = true;
  services.plex.user = "nazarii";
  services.plex.group = "users";
  services.plex.openFirewall = true;
  systemd.services.plex.serviceConfig.ProtectHome = lib.mkForce false;

  services.jackett = {
    enable = true;
    user = "nazarii";
    group = "users";
  };

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
}
