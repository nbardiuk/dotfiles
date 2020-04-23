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
      caffeine = "xset s off -dpms && systemctl --user stop xautolock-session.service";
      decaff = "xset s on -dpms && systemctl --user start xautolock-session.service";
      upgrade = "sudo sysctl -p && sudo nixos-rebuild switch --upgrade && home-manager switch && nvim +PlugInstall +UpdateRemotePlugins +qa";

      l = "exa --long --header --time-style=long-iso";
      ll = l;
      ls = l;
      la = l + " -all";
      lart = la + " --sort=newest";
      lat = la + " --sort=oldest";
      las = la + " --sort=size";
      lars = la + " --sort=size --reverse";
      tree = la + " --tree";
    };

    initExtra = ''
      eval $(keychain --quiet --agents ssh --eval id_rsa)
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
  ];
}
