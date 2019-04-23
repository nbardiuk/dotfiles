{ config, pkgs, ... }:

let
  chunkwm = pkgs.recurseIntoAttrs (pkgs.callPackage ~/.config/nixpkgs/pkgs/chunkwm {
    inherit (pkgs) callPackage stdenv fetchFromGitHub imagemagick;
    inherit (pkgs.darwin.apple_sdk.frameworks) Carbon Cocoa ApplicationServices;
  });
in
{
  nixpkgs.config.allowUnfree = true;
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    cabal-install
    chunkwm.border
    chunkwm.core
    chunkwm.ffm
    chunkwm.tiling
    direnv
    htop
    jdk
    keychain
    mpv-with-scripts
    ncdu
    neovim
    neovim-remote
    nodejs
    nodePackages.javascript-typescript-langserver
    nodePackages.typescript
    python3
    python37Packages.pip
    python37Packages.virtualenv
    ranger
    ripgrep
    ruby
    shellcheck
    stack
    stow
    syncthing
    terraform
    tree
    vale                      # prose linter
    vim-vint                  # vim linter
    vscode-with-extensions
    w3m
    wget
    youtube-dl
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

  launchd.user.agents.syncthing = {
    # https://github.com/eqyiel/dotfiles/blob/3d2c8b61da6f4636c650b8525fa1aeebfd5996d6/nix/.config/nixpkgs/darwin/config/default.nix
    serviceConfig.ProgramArguments = [ "${pkgs.syncthing}/bin/syncthing" "-no-browser" "-no-restart" ];
    serviceConfig.EnvironmentVariables = {
      HOME = "/Users/${(builtins.getEnv "USER")}";
      STNOUPGRADE = "1"; # disable spammy automatic upgrade check
    };
    serviceConfig.KeepAlive = true;
    serviceConfig.ProcessType = "Background";
    serviceConfig.StandardOutPath = "/Users/${(builtins.getEnv "USER")}/Library/Logs/Syncthing.log";
    serviceConfig.StandardErrorPath = "/Users/${(builtins.getEnv "USER")}/Library/Logs/Syncthing-Errors.log";
    serviceConfig.LowPriorityIO = true;
  };


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
    chunkc set mouse_follows_focus           all
    chunkc set mouse_resize_window           alt
    chunkc set mouse_move_window             ctrl
    chunkc set window_region_locked          1

    # chwm-sa additions
    # https://github.com/koekeishiya/chwm-sa
    chunkc set window_float_topmost          1
    chunkc set window_fade_inactive          1
    chunkc set window_fade_alpha             0.9
    chunkc set window_fade_duration          0.1
    chunkc tiling::rule --owner Dash --state float
    chunkc tiling::rule --owner Spotify --desktop 5
    chunkc tiling::rule --owner Slack --desktop 4
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
    alt - b : chunkc tiling::desktop --layout bsp
    alt - m : chunkc tiling::desktop --layout monocle

    alt - r : chunkc tiling::desktop --rotate 90

    # resize
    alt - a : chunkc tiling::window --use-temporary-ratio  0.03 --adjust-window-edge west;  chunkc tiling::window --use-temporary-ratio -0.03 --adjust-window-edge east;
    alt - d : chunkc tiling::window --use-temporary-ratio -0.03 --adjust-window-edge west;  chunkc tiling::window --use-temporary-ratio  0.03 --adjust-window-edge east;
    alt - w : chunkc tiling::window --use-temporary-ratio  0.05 --adjust-window-edge north; chunkc tiling::window --use-temporary-ratio -0.05 --adjust-window-edge south;
    alt - s : chunkc tiling::window --use-temporary-ratio -0.05 --adjust-window-edge north; chunkc tiling::window --use-temporary-ratio  0.05 --adjust-window-edge south;

    # kill focused window
    shift + alt - q : chunkc tiling::window --close

    # change focus
    alt - h : chunkc tiling::window --focus west
    alt - j : chunkc tiling::window --focus south
    alt - k : chunkc tiling::window --focus north
    alt - l : chunkc tiling::window --focus east

    # move focused window
    shift + alt - h : chunkc tiling::window --warp west
    shift + alt - j : chunkc tiling::window --warp south
    shift + alt - k : chunkc tiling::window --warp north
    shift + alt - l : chunkc tiling::window --warp east

    # focus workspace
    alt - p : chunkc tiling::desktop --focus prev
    alt - n : chunkc tiling::desktop --focus next
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
