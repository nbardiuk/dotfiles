{ config, lib, pkgs, ... }:
{

  programs.starship = {
    enable = true;
    settings = {
      directory = {
        truncation_length = 7;
        truncation_symbol = "/… /";
      };
      git_branch.ignore_branches = [ "main" "master" ];
      nix_shell.format = "via $symbol";
      scala.disabled = true;
      time.disabled = false;
    };
  };

  programs.zsh = rec {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    history.expireDuplicatesFirst = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "bgnotify"
        "git"
        "tmux"
      ];
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
      CDPATH = lib.concatStringsSep ":" [
        "${config.home.homeDirectory}/code"
        "${config.home.homeDirectory}"
      ];
    };

    shellAliases = rec {
      l = "eza --long --git --header --time-style=long-iso";
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
    nerdfonts # shell icons
  ];
}
