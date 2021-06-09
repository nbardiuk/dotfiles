{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";

  environment.variables.LANG = "en_IE.UTF-8";
  environment.variables.LC_ALL = "en_IE.UTF-8";

  time.timeZone = "Europe/Lisbon";

  networking.hostName = "bardiuk-ee";

  documentation.enable = true;

  users.nix.configureBuildUsers = true;
  services.nix-daemon.enable = false;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
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

  services.yabai.enable = true;
  services.yabai.enableScriptingAddition = true;
  services.yabai.config.layout = "bsp";
  services.yabai.package = pkgs.yabai.overrideAttrs (o: rec {
    version = "3.3.10";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "025ww9kjpy72in3mbn23pwzf3fvw0r11ijn1h5pjqvsdlak91h9i";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./archive/bin/yabai $out/bin/yabai
      cp ./archive/doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });

  services.skhd.enable = true;
  services.skhd.skhdConfig = ''
    # enter fullscreen mode for the focused container
    cmd + alt - f : yabai -m window --toggle zoom-fullscreen

    # change focus between tiling / floating windows
    cmd + shift + alt - space : yabai -m window --toggle float

    # change layout of desktop
    cmd + alt - w : yabai -m space --layout stack
    cmd + alt - e : yabai -m space --layout bsp

    # change focus
    cmd + alt - h : yabai -m window --focus west
    cmd + alt - j : yabai -m window --focus south
    cmd + alt - k : yabai -m window --focus north
    cmd + alt - l : yabai -m window --focus east

    # move focused window
    cmd + shift + alt - h : yabai -m window --warp west
    cmd + shift + alt - j : yabai -m window --warp south
    cmd + shift + alt - k : yabai -m window --warp north
    cmd + shift + alt - l : yabai -m window --warp east

    cmd + alt - 1 : yabai -m space --focus 1
    cmd + alt - 2 : yabai -m space --focus 2
    cmd + alt - 3 : yabai -m space --focus 3
    cmd + alt - 4 : yabai -m space --focus 4
    cmd + alt - 5 : yabai -m space --focus 5
    cmd + alt - 6 : yabai -m space --focus 6
    cmd + alt - 7 : yabai -m space --focus 7
    cmd + alt - 8 : yabai -m space --focus 8
    cmd + alt - 9 : yabai -m space --focus 9
    cmd + alt - 0 : yabai -m space --focus 10

    # move focused container to workspace
    cmd + shift + alt - 1 : yabai -m window --space  1; yabai -m space --focus 1
    cmd + shift + alt - 2 : yabai -m window --space  2; yabai -m space --focus 2
    cmd + shift + alt - 3 : yabai -m window --space  3; yabai -m space --focus 3
    cmd + shift + alt - 4 : yabai -m window --space  4; yabai -m space --focus 4
    cmd + shift + alt - 5 : yabai -m window --space  5; yabai -m space --focus 5
    cmd + shift + alt - 6 : yabai -m window --space  6; yabai -m space --focus 6
    cmd + shift + alt - 7 : yabai -m window --space  7; yabai -m space --focus 7
    cmd + shift + alt - 8 : yabai -m window --space  8; yabai -m space --focus 8
    cmd + shift + alt - 9 : yabai -m window --space  9; yabai -m space --focus 9
    cmd + shift + alt - 0 : yabai -m window --space  10; yabai -m space --focus 10
  '';
}
