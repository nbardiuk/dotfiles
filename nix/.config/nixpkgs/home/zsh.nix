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
        "vi-mode"
      ];
      theme = "refined";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +set\\ filetype=man -";
      SUDO_EDITOR = "nvim";
      ZSH_TMUX_AUTOSTART = true;
    };

    shellAliases = rec {
      caffeine = "xset s off -dpms && systemctl --user stop xautolock-session.service";
      decaff = "xset s on -dpms && systemctl --user start xautolock-session.service";

      l = "exa --long --header --time-style=long-iso";
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
      eval $(keychain --quiet --agents gpg,ssh --eval id_rsa 1D8729AEF5622C0F7EA209C1C9C1904D44CDCDA1)
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
    xsel     # clipboard
  ];
}
