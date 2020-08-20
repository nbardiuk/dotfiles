{ config, pkgs, ... }:
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

  # exfat support
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  # Graphics
  # hardware.nvidia.optimus_prime.sync.enable = true;
  hardware.nvidia.optimus_prime.enable = true;
  hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:1:0:0";
  services.xserver.videoDrivers = [ "modsetting" "nvidia" ];
  services.xserver.dpi = 96;

  hardware.opengl.driSupport32Bit = false; # enbales opengl for 32bit apps
  hardware.pulseaudio.support32Bit = false;

  services.dbus.packages = with pkgs; [
    gnome3.dconf # fixes https://github.com/rycee/home-manager/pull/436#issuecomment-449755377
    blueman # for blueman applet https://github.com/rycee/home-manager/blob/6aa44d62ad6526177a8c1f1babe1646c06738614/modules/services/blueman-applet.nix#L15
  ];

  nixpkgs.config.allowUnfree = true;
  systemd.packages = with pkgs; [
    blueman # for blueman applet https://github.com/rycee/home-manager/blob/6aa44d62ad6526177a8c1f1babe1646c06738614/modules/services/blueman-applet.nix#L15
  ];

  networking.hostName = "bardiuk"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IE.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    blueman # for blueman applet https://github.com/rycee/home-manager/blob/6aa44d62ad6526177a8c1f1babe1646c06738614/modules/services/blueman-applet.nix#L15
    vim
    pciutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.light.enable = true;
  programs.adb.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  hardware.printers.ensurePrinters = [
    {
      name = "hpenvy5640";
      deviceUri = "ipp://HPD639B4";
      model = "drv:///hp/hpcups.drv/hp-envy_5640_series.ppd";
      ppdOptions.PageSize = "A4";
    }
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.bluetooth.enable = true;
  # hardware.bluetooth.package = pkgs.bluez.override { enableMidi = true; };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,ua";
  services.xserver.xkbOptions = "grp:shifts_toggle";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;
  services.xserver.libinput.clickMethod = "clickfinger";
  services.xserver.libinput.scrollMethod = "twofinger";
  services.xserver.libinput.additionalOptions = ''
    Option "TappingButtonMap" "lmr"
  '';

  services.xserver.wacom.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = false;
  virtualisation.virtualbox.host.enableExtensionPack = true;

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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
    ];
    trustedUsers = [ "root" "nazarii" ];
  };

  services.acpid.enable = true;
  services.acpid.logEvents = true;

  services.sysstat.enable = true;
}
