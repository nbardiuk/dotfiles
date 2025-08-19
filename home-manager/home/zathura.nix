{ ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      adjust-open = "width"; # Defines which auto adjustment mode should be used if a document is loaded.
      continuous-hist-save = true; # Tells zathura whether to save document history at each page change or only when closing a document.
      scroll-page-aware = true; # Defines if scrolling by half or full pages stops at page boundaries.
      selection-clipboard = "clipboard"; # Defines the X clipboard into which mouse-selected data will be written
      statusbar-home-tilde = true; # Display a short version of the file path, which replaces $HOME with ~, in the statusbar
      window-title-home-tilde = true; # Display a short version of the file path, which replaces $HOME with ~, in the window title.
      page-padding = 0; # The page padding defines the gap in pixels between each rendered page.
    };
  };

  xdg.mime.enable = true;
  xdg.desktopEntries = {
    zathura = {
      name = "zathura";
      type = "Application";
      comment = "A minimalistic PDF viewer";
      exec = "zathura --fork %f";
      terminal = false;
      categories = [ "Office" "Viewer" ];
      mimeType = [ "application/pdf" ];
    };
  };
}
