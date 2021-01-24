{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";

  environment.variables.LANG = "en_IE.UTF-8";
  environment.variables.LC_ALL = "en_IE.UTF-8";

  time.timeZone = "Europe/Lisbon";

  networking.hostName = "bardiuk-ee";

  programs.man.enable = true;

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
  services.yabai.package = pkgs.yabai;
  services.yabai.enableScriptingAddition = false;
  services.yabai.config.layout = "bsp";

  services.skhd.enable = true;
  services.skhd.skhdConfig = ''
    # enter fullscreen mode for the focused container
    alt - f : yabai -m window --toggle zoom-fullscreen

    # change focus between tiling / floating windows
    shift + alt - space : yabai -m window --toggle float

    # change layout of desktop
    alt - w : yabai -m space --layout monocle
    alt - e : yabai -m space --layout bsp


    # change focus
    alt - h : yabai -m window --focus west
    alt - j : yabai -m window --focus south
    alt - k : yabai -m window --focus north
    alt - l : yabai -m window --focus east

    # move focused window
    shift + alt - h : yabai -m window --warp west
    shift + alt - j : yabai -m window --warp south
    shift + alt - k : yabai -m window --warp north
    shift + alt - l : yabai -m window --warp east

    alt - 1 : yabai -m space --focus 1
    alt - 2 : yabai -m space --focus 2
    alt - 3 : yabai -m space --focus 3
    alt - 4 : yabai -m space --focus 4
    alt - 5 : yabai -m space --focus 5
    alt - 6 : yabai -m space --focus 6
    alt - 7 : yabai -m space --focus 7
    alt - 8 : yabai -m space --focus 8
    alt - 9 : yabai -m space --focus 9
    alt - 0 : yabai -m space --focus 10

    # move focused container to workspace
    shift + alt - 1 : yabai -m window --space  1; yabai -m space --focus 1
    shift + alt - 2 : yabai -m window --space  2; yabai -m space --focus 2
    shift + alt - 3 : yabai -m window --space  3; yabai -m space --focus 3
    shift + alt - 4 : yabai -m window --space  4; yabai -m space --focus 4
    shift + alt - 5 : yabai -m window --space  5; yabai -m space --focus 5
    shift + alt - 6 : yabai -m window --space  6; yabai -m space --focus 6
    shift + alt - 7 : yabai -m window --space  7; yabai -m space --focus 7
    shift + alt - 8 : yabai -m window --space  8; yabai -m space --focus 8
    shift + alt - 9 : yabai -m window --space  9; yabai -m space --focus 9
    shift + alt - 0 : yabai -m window --space  10; yabai -m space --focus 10
  '';
}
