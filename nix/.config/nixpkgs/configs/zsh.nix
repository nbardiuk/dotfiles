{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    history.expireDuplicatesFirst = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "bgnotify"
        "common-aliases"
        "git"
      ];
      theme = "refined";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +set\\ filetype=man -";
      SUDO_EDITOR = "nvim";
      TERM = "xterm-256color";
    };

    shellAliases = {
      caffeine = "xset s off -dpms && pkill xautolock";
      vi = "nvim";
      view = "nvim -R";
      upgrade = "sudo sysctl -p && sudo nixos-rebuild switch --upgrade && home-manager switch && nvim +PlugInstall +UpdateRemotePlugins +qa";
    };

    initExtra = ''
      eval $(keychain --eval --quiet ~/.ssh/id_rsa)
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_FIND_NO_DUPS
    '';
  };

  home.packages = with pkgs; [
    keychain                  # ssh agent
  ];
}
