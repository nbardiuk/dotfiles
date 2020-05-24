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
        alignment = "left";
        allow_markup = "yes";
        bounce_freq = 0;
        browser = "firefox -new-tab";
        follow = "mouse";
        font = "Iosevka 12";
        format = "<b>%s</b>\\n%b\\n%p";
        geometry = "400x150-50+50";
        history_length = 20;
        horizontal_padding = 8;
        icon_position = "left";
        idle_threshold = 90;
        ignore_newline = "no";
        indicate_hidden = "yes";
        line_height = 0;
        max_icon_size = 32;
        monitor = 0;
        padding = 8;
        separator_color = "frame";
        separator_height = 2;
        show_age_threshold = 60;
        show_indicators = "no";
        shrink = "no";
        sort = "yes";
        startup_notification = false;
        sticky_history = "yes";
        transparency = 0;
        word_wrap = "yes";
      };
      frame = {
        color = "#2f343f";
        width = 3;
      };
      shortcuts ={
        close = "mod4+mod1+space";
        close_all = "mod4+mod1+shift+space";
        context = "mod4+shift+period";
        history = "mod4+grave";
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
}
