{ ... }:
let
  # https://github.com/aaron-williamson/base16-alacritty
  base16-github = {
    colors = {
      primary = {
        background = "0xffffff";
        foreground = "0x333333";
      };

      cursor = {
        text = "0xffffff";
        cursor = "0x333333";
      };

      normal = {
        black = "0xffffff";
        red = "0xed6a43";
        green = "0x183691";
        yellow = "0x795da3";
        blue = "0x795da3";
        magenta = "0xa71d5d";
        cyan = "0x183691";
        white = "0x333333";
      };

      bright = {
        black = "0x969896";
        red = "0x0086b3";
        green = "0xf5f5f5";
        yellow = "0xc8c8fa";
        blue = "0xe8e8e8";
        magenta = "0xffffff";
        cyan = "0x333333";
        white = "0xffffff";
      };
    };

    draw_bold_text_with_bright_colors = false;
  };
  base16-grayscale-light-my = {
    colors = {
      primary = {
        background = "0xffffff";
        foreground = "0x000000";
      };

      cursor = {
        text = "0xffffff";
        cursor = "0x000000";
      };

      normal = {
        black = "0xffffff";
        red = "0x7c7c7c";
        green = "0x8e8e8e";
        yellow = "0xa0a0a0";
        blue = "0x686868";
        magenta = "0x747474";
        cyan = "0x868686";
        white = "0x000000";
      };

      bright = {
        black = "0xababab";
        red = "0x999999";
        green = "0xe3e3e3";
        yellow = "0xb9b9b9";
        blue = "0x525252";
        magenta = "0x252525";
        cyan = "0x5e5e5e";
        white = "0x101010";
      };
    };
    draw_bold_text_with_bright_colors = false;
  };
in
{
  programs.alacritty.enable = true;
  programs.alacritty.settings = base16-grayscale-light-my // {

    # Allow terminal applications to change Alacritty's window title.
    window.dynamic_title = true;

    # Disable scroll buffer, use tmux instead
    scrolling.history = 0;

    # The cursor is temporarily hidden when typing
    mouse.hide_when_typing = true;

    # Font configuration (changes require restart)
    font = {
      normal.family = "Iosevka";
      size = 9;
    };
  };
}
