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

  homebrew.enable = true;
  homebrew.casks = [ "obsidian" "stats" ];

  networking.dns = [ "8.8.8.8" "8.8.4.4" ];
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Ethernet"
  ];
}
