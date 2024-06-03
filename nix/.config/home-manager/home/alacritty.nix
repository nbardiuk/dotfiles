{ ... }:
let
  grey = {
    # https://github.com/yorickpeterse/nvim-grey/blob/main/colors/grey.lua
    colors = {
      primary = {
        background = "#F2F2F2";
        foreground = "#000000";
      };

      cursor = {
        text = "#DDDDDD";
        cursor = "#000000";
      };

      normal = {
        black = "#000000";
        red = "#C4331D";
        green = "#1C5708";
        yellow = "#BF8F00";
        blue = "#1561B8";
        magenta = "#5C21A5";
        cyan = "#007872";
        white = "#FFFFFF";
      };

      bright = {
        black = "#000000";
        red = "#C4331D";
        green = "#1C5708";
        yellow = "#BF8F00";
        blue = "#1561B8";
        magenta = "#5C21A5";
        cyan = "#007872";
        white = "#FFFFFF";
      };
    };
  };

  paper = {
    colors = {
      primary = {
        background = "#F2EEDE";
        foreground = "#000000";
      };

      normal = {
        black = "#000000";
        red = "#CC3E28";
        green = "#216609";
        yellow = "#B58900";
        blue = "#1E6FCC";
        magenta = "#5C21A5";
        cyan = "#158C86";
        white = "#AAAAAA";
      };

      bright = {
        black = "#555555";
        red = "#CC3E28";
        green = "#216609";
        yellow = "#B58900";
        blue = "#1E6FCC";
        magenta = "#5C21A5";
        cyan = "#158C86";
        white = "#AAAAAA";
      };
    };
  };

in
{
  programs.alacritty.enable = true;
  programs.alacritty.settings = grey // {

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
