{ pkgs, ... }:
{
  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
      package = pkgs.dejavu_fonts;
    };
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };
    theme = {
      name = "Arc-Darker";
      package = pkgs.arc-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 48;
  };
}
