{ ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      adjust-open = "width"; # S
      continuous-hist-save = true;
      scroll-page-aware = true;
      selection-clipboard = "clipboard";
      statusbar-home-tilde = true;
      window-title-home-tilde = true;
    };
  };
}
