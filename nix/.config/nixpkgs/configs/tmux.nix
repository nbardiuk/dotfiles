{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;

    shortcut = "a";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    reverseSplit = true;

    disableConfirmationPrompt = true;

    terminal = "screen-256color";

    historyLimit = 50000;

    extraConfig = ''
      set -g default-command zsh

      set-option -g status-position top
      set -g status-right ""

      #### COLOUR (Solarized light)
      set-option -g status-bg white #base2
      set-option -g status-fg yellow #yellow
      set-option -g display-panes-active-colour blue #blue
      set-option -g display-panes-colour brightred #orange
      set-window-option -g clock-mode-colour green #green
      set-window-option -g window-status-bell-style fg=white,bg=red #base2, red
    '';

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.yank;
        extraConfig = ''
          set -g @yank_selection 'clipboard'
        '';
      }
    ];
  };
}
