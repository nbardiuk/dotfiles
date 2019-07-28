{ ... }: {
  programs.termite = {
    enable = true;
    browser = "xdg-open";
    font = "Iosevka Term 12";
    scrollbackLines = -1;
    colorsExtra = ''
      # Github iTerm https://iterm2colorschemes.com/
      # special
      foreground      = #3e3e3e
      foreground_bold = #3e3e3e
      cursor          = #3e3e3e
      background      = #f4f4f4

      # black
      color0  = #3e3e3e
      color8  = #666666

      # red
      color1  = #970b16
      color9  = #de0000

      # green
      color2  = #07962a
      color10 = #87d5a2

      # yellow
      color3  = #f8eec7
      color11 = #f1d007

      # blue
      color4  = #003e8a
      color12 = #2e6cba

      # magenta
      color5  = #e94691
      color13 = #ffa29f

      # cyan
      color6  = #89d1ec
      color14 = #1cfafe

      # white
      color7  = #ffffff
      color15 = #ffffff
    '';
  };
}
