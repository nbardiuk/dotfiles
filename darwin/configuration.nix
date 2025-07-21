{ ... }:
{
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [ "nazarii" ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  system.stateVersion = 5;
  system.primaryUser = "nazarii";
  users.users.nazarii.home = "/Users/nazarii";

  # enable repeating keys
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  homebrew.enable = true;
  homebrew.taps = [
  ];
  homebrew.brews = [
    "cocoapods"
    "ffmpeg"
    "podman"
    "podman-compose"
  ];
  homebrew.casks = [
    "caffeine"
    "dbeaver-community"
    "elgato-wave-link"
    "firefox"
    "google-chrome"
    "grammarly-desktop"
    "karabiner-elements"
    "macs-fan-control"
    "obs"
    "podman-desktop"
    "raycast"
    "rectangle"
    "slack"
    "stats"
    "temurin@21"
    "transcribe"
  ];
  homebrew.onActivation.cleanup = "uninstall";

  networking.dns = [ "8.8.8.8" "1.1.1.1" ];
  networking.hostName = "bardiuk-mac";
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Ethernet"
  ];
}
