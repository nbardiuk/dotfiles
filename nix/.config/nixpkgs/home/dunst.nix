{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
      size = "16x16";
    };
    settings = {
      global = {
        alignment = "left"; # how the text should be aligned within the notification
        allow_markup = "yes";
        bounce_freq = 0;
        browser = "firefox -new-tab";
        follow = "mouse"; # where the notifications should be placed in a multi-monitor setup
        font = "Iosevka 12";
        format = "<b>%s</b>\\n%b\\n%p";
        geometry = "400x150-50+50";
        history_length = 50; # number of notifications that will be kept in history
        horizontal_padding = 8;
        icon_position = "left";
        idle_threshold = 90; # Don't timeout notifications if user is idle longer than this time
        ignore_newline = "no";
        line_height = 0;
        max_icon_size = 32;
        monitor = 0; # on which monitor the notifications should be displayed in
        padding = 8;
        separator_color = "frame";
        separator_height = 2;
        show_age_threshold = -1; # Show age of message if message is older than this time
        show_indicators = "yes"; # Show an indicator if a notification contains actions
        shrink = "no";
        sort = "yes"; # display notifications with higher urgency above the others
        startup_notification = false;
        sticky_history = "yes";
        transparency = 0;
        word_wrap = "yes";
        notification_limit = 6; # The number of notifications that can appear at one time.
        indicate_hidden = "yes"; # notification indicating how many notifications are not being displayed due to the notification limit
      };
      frame = {
        color = "#2f343f";
        width = 3;
      };
      urgency_low = {
        background = "#2f343f";
        foreground = "#676E7D";
        timeout = 30;
      };
      urgency_normal = {
        background = "#2f343f";
        foreground = "#f3f4f5";
        timeout = 60;
      };
      urgency_critical = {
        background = "#E53935";
        foreground = "#f3f4f5";
        timeout = 0;
      };
    };
  };
  home.packages = with pkgs; [
    libnotify
  ];
}
