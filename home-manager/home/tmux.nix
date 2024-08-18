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

    terminal = "alacritty";

    historyLimit = 69000;

    extraConfig = ''
      # Add truecolor support
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

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

      bind e choose-tree -Z
      unbind-key w

      # create new window in current path
      bind c new-window -c '#{pane_current_path}'
      bind 2 run "(tmux select-window -t 2) || tmux new-window -c '#{pane_current_path}'"
      bind 3 run "(tmux select-window -t 3) || tmux new-window -c '#{pane_current_path}'"
      bind 4 run "(tmux select-window -t 4) || tmux new-window -c '#{pane_current_path}'"
      bind 5 run "(tmux select-window -t 5) || tmux new-window -c '#{pane_current_path}'"
      bind 6 run "(tmux select-window -t 6) || tmux new-window -c '#{pane_current_path}'"
      bind 7 run "(tmux select-window -t 7) || tmux new-window -c '#{pane_current_path}'"
      bind 8 run "(tmux select-window -t 8) || tmux new-window -c '#{pane_current_path}'"
      bind 9 run "(tmux select-window -t 9) || tmux new-window -c '#{pane_current_path}'"
      set -g renumber-window on

      # move pane between windows
      bind-key C-1 move-pane -t :1
      bind-key C-2 move-pane -t :2
      bind-key C-3 move-pane -t :3
      bind-key C-4 move-pane -t :4
      bind-key C-5 move-pane -t :5
      bind-key C-6 move-pane -t :6
      bind-key C-7 move-pane -t :7
      bind-key C-8 move-pane -t :8
      bind-key C-9 move-pane -t :9

      # move pane inside window
      bind-key H swap-pane -d -t '{left-of}'
      bind-key L swap-pane -d -t '{right-of}'
      bind-key K swap-pane -d -t '{up-of}'
      bind-key J swap-pane -d -t '{down-of}'

      # layouts
      bind-key C-V select-layout even-horizontal
      bind-key C-v run-shell "tmux setw main-pane-width $(($(tmux display -p '#{window_width}') * 66 / 100)); tmux select-layout main-vertical"
      bind-key C-H select-layout even-vertical
      bind-key C-h run-shell "tmux setw main-pane-height $(($(tmux display -p '#{window_height}') * 66 / 100)); tmux select-layout main-horizontal"
      bind-key C-t select-layout tiled

      #### COLOUR see ./alacritty.nix for exact values of terminal colors
      set -g status-bg "#DDDDDD" # same as vim status bar
      set -g status-fg black
      set -g display-panes-active-colour blue
      set -g display-panes-colour brightred
      set-window-option -g clock-mode-colour green
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
