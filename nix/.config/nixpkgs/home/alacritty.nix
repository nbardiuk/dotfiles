{ ... }:
let
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

    shell.program = "zsh";

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
