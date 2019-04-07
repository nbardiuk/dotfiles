{ config, pkgs, ... }:

let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
  };
  # chunkwm = nur.repos.yurrriq.pkgs.chunkwm;
  chunkwm = pkgs.recurseIntoAttrs (pkgs.callPackage ~/.config/nixpkgs/pkgs/chunkwm {
    inherit (pkgs) callPackage stdenv fetchFromGitHub imagemagick;
    inherit (pkgs.darwin.apple_sdk.frameworks) Carbon Cocoa ApplicationServices;
  });
in
{
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    chunkwm.border
    chunkwm.core
    chunkwm.ffm
    chunkwm.tiling
    cabal-install # haskell build
    htop # better top
    keychain # ssh agent
    neovim # editor
    nox # nix helper
    ranger # cli file manager
    ripgrep # better grep
    shellcheck # bash linting
    stack # haskell build
    stow # dotfiles management
    w3m # cli browser, shows images
  ];

  environment.variables.LANG = "en_IE.UTF-8";
  environment.variables.LC_ALL = "en_IE.UTF-8";

  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    iosevka-bin
  ];

  time.timeZone = "Europe/Lisbon";

  networking.hostName = "bardiuk-ee";

  programs.man.enable = true;

  # Whether to enable nix-index and it's command-not-found helper.
  programs.nix-index.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 8;
  nix.buildCores = 8;

  services.chunkwm.enable = true;
  services.chunkwm.hotload = false;
  services.chunkwm.package = chunkwm.core;
  services.chunkwm.plugins.dir = "/run/current-system/sw/bin/chunkwm-plugins/";
  services.chunkwm.plugins."tiling".config = ''
    chunkc set desktop_padding_step_size     0
    chunkc set desktop_gap_step_size         0
    chunkc set global_desktop_offset_top     0
    chunkc set global_desktop_offset_bottom  0
    chunkc set global_desktop_offset_left    0
    chunkc set global_desktop_offset_right   0
    chunkc set global_desktop_offset_gap     0
    chunkc set bsp_spawn_left                1
    chunkc set bsp_split_mode                optimal
    chunkc set bsp_optimal_ratio             1.618
    chunkc set bsp_split_ratio               0.66
    chunkc set window_focus_cycle            all
    chunkc set mouse_follows_focus           1
    chunkc set window_region_locked          1

    # chwm-sa additions
    # https://github.com/koekeishiya/chwm-sa
    chunkc set window_float_topmost          1
    chunkc set window_fade_inactive          1
    chunkc set window_fade_alpha             0.9
    chunkc set window_fade_duration          0.1
    chunkc tiling::rule --owner Dash --state float
    chunkc tiling::rule --owner Spotify --desktop 5 --follow-desktop
    chunkc tiling::rule --owner Slack --desktop 4 --follow-desktop
  '';

  launchd.user.agents.chwm-sa = {
    # installation https://koekeishiya.github.io/chunkwm/docs/sa.html
    command = "${chunkwm.core}/bin/chunkwm --load-sa";
    serviceConfig.KeepAlive = false;
    serviceConfig.ProcessType = "Background";
    serviceConfig.RunAtLoad = true;
  };

  services.skhd.enable = true;
  services.skhd.skhdConfig = ''
    # enter fullscreen mode for the focused container
    alt - f : chunkc tiling::window --toggle fullscreen

    # change focus between tiling / floating windows
    shift + alt - space : chunkc tiling::window --toggle float

    # change layout of desktop
    alt - e : chunkc tiling::desktop --layout bsp
    alt - s : chunkc tiling::desktop --layout monocle

    # kill focused window
    shift + alt - q : chunkc tiling::window --close

    # change focus
    alt - h : chunkc tiling::window --focus west
    alt - j : chunkc tiling::window --focus south
    alt - k : chunkc tiling::window --focus north
    alt - l : chunkc tiling::window --focus east
    alt - p : chunkc tiling::window --focus prev
    alt - n : chunkc tiling::window --focus next

    # move focused window
    shift + alt - h : chunkc tiling::window --warp west
    shift + alt - j : chunkc tiling::window --warp south
    shift + alt - k : chunkc tiling::window --warp north
    shift + alt - l : chunkc tiling::window --warp east

    alt - r : chunkc tiling::desktop --rotate 90

    # focus workspace
    alt - 1 : chunkc tiling::desktop --focus 1
    alt - 2 : chunkc tiling::desktop --focus 2
    alt - 3 : chunkc tiling::desktop --focus 3
    alt - 4 : chunkc tiling::desktop --focus 4
    alt - 5 : chunkc tiling::desktop --focus 5
    alt - 6 : chunkc tiling::desktop --focus 6
    alt - 7 : chunkc tiling::desktop --focus 7
    alt - 8 : chunkc tiling::desktop --focus 8
    alt - 9 : chunkc tiling::desktop --focus 9
    alt - 0 : chunkc tiling::desktop --focus 10

    # move focused container to workspace
    shift + alt - p : chunkc tiling::window --send-to-desktop prev
    shift + alt - n : chunkc tiling::window --send-to-desktop next
    shift + alt - 1 : chunkc tiling::window --send-to-desktop 1
    shift + alt - 2 : chunkc tiling::window --send-to-desktop 2
    shift + alt - 3 : chunkc tiling::window --send-to-desktop 3
    shift + alt - 4 : chunkc tiling::window --send-to-desktop 4
    shift + alt - 5 : chunkc tiling::window --send-to-desktop 5
    shift + alt - 6 : chunkc tiling::window --send-to-desktop 6
    shift + alt - 7 : chunkc tiling::window --send-to-desktop 7
    shift + alt - 8 : chunkc tiling::window --send-to-desktop 8
    shift + alt - 9 : chunkc tiling::window --send-to-desktop 9
    shift + alt - 0 : chunkc tiling::window --send-to-desktop 10
  '';
}
