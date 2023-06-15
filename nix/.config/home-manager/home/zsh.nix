{ config, lib, pkgs, ... }:
let
  minutes = m: (m * 60);
in
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
        "git-auto-fetch"
        "tmux"
      ];
      theme = "refined";
    };

    sessionVariables = {
      USE_GKE_GCLOUD_AUTH_PLUGIN = true; # https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +Man!";
      SUDO_EDITOR = "nvim";
      ZSH_TMUX_AUTOSTART = true;
      ZSH_TMUX_CONFIG = "${config.home.homeDirectory}/.config/tmux/tmux.conf";
      ZSH_TMUX_UNICODE = true;
      GIT_AUTO_FETCH_INTERVAL = minutes 10;
      CDPATH = lib.concatStringsSep ":" [
        "${config.home.homeDirectory}/code"
        "${config.home.homeDirectory}"
      ];
    };

    shellAliases = rec {
      l = "exa --long --git --header --time-style=long-iso";
      ll = l;
      ls = l;
      la = l + " -all";
      latr = la + " --sort=newest";
      lat = la + " --sort=oldest";
      las = la + " --sort=size";
      lasr = la + " --sort=size --reverse";
      tree = la + " --tree";
      copy = "xsel --clipboard --input";
      paste = "xsel --clipboard --output";
    };

    initExtra = ''
      eval $(keychain --quiet --agents ssh --eval id_ed25519)
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_FIND_NO_DUPS

      lt () {
        ${shellAliases.tree + " --level="}"$1";
      }
    '';
  };

  home.packages = with pkgs; [
    gnupg
    keychain # for ssh,gpg agents
    xsel # clipboard
  ];
}
