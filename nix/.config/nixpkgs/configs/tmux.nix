{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;

    shortcut = "s";
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    secureSocket = false;

    disableConfirmationPrompt = true;

    terminal = "screen-256color";

    historyLimit = 50000;

    extraConfig = ''
      set -g default-command zsh

      set -g mouse on

      set-option -g status-position top
      set -g status-right ""

      set -g set-titles on
      set -g set-titles-string "#S / #W"

      bind -T copy-mode-vi v send-keys -X begin-selection
      bind v split-window -h -c '#{pane_current_path}'
      bind s split-window -v -c '#{pane_current_path}'

      # create new window in current path
      bind c new-window -c '#{pane_current_path}'
      set-option -g renumber-window on

      # move current break to a new window
      bind-key b break-pane -d

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
      {
        plugin = tmuxPlugins.vim-tmux-navigator;
      }
    ];
  };
}
