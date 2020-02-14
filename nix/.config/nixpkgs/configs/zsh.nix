{ pkgs, ... }:
{
  programs.zsh = rec {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    history.expireDuplicatesFirst = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "bgnotify"
        "git"
        "tmux"
      ];
      theme = "refined";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +set\\ filetype=man -";
      SUDO_EDITOR = "nvim";
      TERM = "xterm-256color";
      ZSH_TMUX_AUTOSTART = true;
    };

    shellAliases = rec {
      caffeine = "xset s off -dpms && pkill xautolock";
      upgrade = "sudo sysctl -p && sudo nixos-rebuild switch --upgrade && home-manager switch && nvim +PlugInstall +UpdateRemotePlugins +qa";

      l = "exa --long --header --time-style=long-iso";
      ll = l;
      ls = l;
      la = l + " -all";
      latr = la + " --sort=newest";
      lat = la + " --sort=oldest";
      las = la + " --sort=size";
      lasr = la + " --sort=size --reverse";
      tree = la + " --tree";
    };

    initExtra = ''
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_FIND_NO_DUPS

      lt () {
        ${shellAliases.tree + " --level="}"$1";
      }
    '';
  };

  services.gpg-agent.enable = true;
  programs.keychain = {
    enable = true;
    keys = ["id_rsa" "1D8729AEF5622C0F7EA209C1C9C1904D44CDCDA1"];
    agents = ["ssh" "gpg"];
    extraFlags = [ "--quiet" ];
    enableZshIntegration = true;
  };
}
