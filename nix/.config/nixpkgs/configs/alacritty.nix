{ ... }: {
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
      # Base16 Github - alacritty color config
      # Defman21
      colors = {
        # Default colors
        primary = {
          background = "0xffffff";
          foreground = "0x333333";
        };

        # Colors the cursor will use if `custom_cursor_colors` is true
        cursor = {
          text = "0xffffff";
          cursor = "0x333333";
        };

        # Normal colors
        normal = {
          black =   "0xffffff";
          red =     "0xed6a43";
          green =   "0x183691";
          yellow =  "0x795da3";
          blue =    "0x795da3";
          magenta = "0xa71d5d";
          cyan =    "0x183691";
          white =   "0x333333";
        };

        # Bright colors
        bright = {
          black =   "0x969896";
          red =     "0x0086b3";
          green =   "0xf5f5f5";
          yellow =  "0xc8c8fa";
          blue =    "0xe8e8e8";
          magenta = "0xffffff";
          cyan =    "0x333333";
          white =   "0xffffff";
        };
      };
      draw_bold_text_with_bright_colors = false;

      # Allow terminal applications to change Alacritty's window title.
      dynamic_title= true;

      # Font configuration (changes require restart)
      font = {
        normal.family = "Iosevka";
        size = 8;
      };
  };
}
