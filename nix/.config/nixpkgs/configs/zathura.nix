{ ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      continuous-hist-save = true;
      selection-clipboard = "clipboard";
      scroll-page-aware = true;
    };
  };
}
