{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [ "nazarii" ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  system.stateVersion = 4;
  users.users.nazarii.home = "/Users/nazarii";

  # enable repeating keys
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  homebrew.enable = true;
  homebrew.taps = [
    "atlassian/tap"
    "hashicorp/tap"
  ];
  homebrew.brews = [
    "atlassian/tap/atlassian-plugin-sdk"
    "hashicorp/tap/vault"
    "nvm"
  ];
  homebrew.casks = [
    "caffeine"
    "docker"
    "elgato-wave-link"
    "grammarly-desktop"
    "stats"
    "temurin@8"
    "temurin@17"
    "temurin@21"
    "whichspace"
  ];
  homebrew.onActivation.cleanup = "uninstall";

  networking.dns = [ "8.8.8.8" "1.1.1.1" ];
  networking.hostName = "bardiuk-exalate";
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Ethernet"
  ];
}
