{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;

    shortcut = "Space";
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    secureSocket = false;

    disableConfirmationPrompt = true;

    terminal = "screen-256color";

    historyLimit = 50000;

    extraConfig = ''
      # Add truecolor support
      set -ga terminal-overrides ",xterm-256color:Tc"

      set -g default-command zsh

      set -g mouse on
      # stay in copy mode on mouse drag end
      unbind-key -T copy-mode-vi MouseDragEnd1Pane

      set -g status-position top
      set -g status-left ""
      set -g status-left-length 0
      set -g status-right ""
      set -g status-right-length 0
      set -g status-interval 0

      set -g set-titles on
      set -g set-titles-string "#T (#{pane_current_path})"

      bind -T copy-mode-vi v send-keys -X begin-selection
      bind v split-window -h -c '#{pane_current_path}'
      bind s split-window -v -c '#{pane_current_path}'

      # create new window in current path
      bind c new-window -c '#{pane_current_path}'
      bind 2 run "(tmux select-window -t 2) || tmux new-window -c '#{pane_current_path}'"
      bind 3 run "(tmux select-window -t 3) || tmux new-window -c '#{pane_current_path}'"
      bind 4 run "(tmux select-window -t 4) || tmux new-window -c '#{pane_current_path}'"
      bind 5 run "(tmux select-window -t 5) || tmux new-window -c '#{pane_current_path}'"
      set -g renumber-window on

      # move current break to a new window
      bind-key b break-pane -d

      #### COLOUR (Solarized light)
      set -g status-bg "#f4f4f4" #white
      set -g status-fg blue
      set -g display-panes-active-colour blue
      set -g display-panes-colour brightred #orange
      set-window-option -g clock-mode-colour green #green
      set-window-option -g window-status-bell-style fg=white,bg=red
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
