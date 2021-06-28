{ lib, pkgs, ... }:
{

  home.packages = with pkgs; [
    k9s
  ];

  home.file."/.k9s/skin.yml".text = ''
    # K9s Solarized Light Skin Contributed by [@leg100](louisgarman@gmail.com)
    foreground: &foreground "#657b83"
    background: &background "#fdf6e3"
    current_line: &current_line "#eee8d5"
    selection: &selection "#eee8d5"
    comment: &comment "#93a1a1"
    cyan: &cyan "#2aa198"
    green: &green "#859900"
    yellow: &yellow "#b58900"
    orange: &orange "#cb4b16"
    magenta: &magenta "#d33682"
    blue: &blue "#268bd2"
    red: &red "#dc322f"

    k9s:
      body:
        fgColor: *foreground
        bgColor: *background
        logoColor: *blue
      info:
        fgColor: *magenta
        sectionColor: *foreground
      dialog:
        fgColor: *foreground
        bgColor: *background
        buttonFgColor: *foreground
        buttonBgColor: *magenta
        buttonFocusFgColor: white
        buttonFocusBgColor: *cyan
        labelFgColor: *orange
        fieldFgColor: *foreground
      frame:
        border:
          fgColor: *selection
          focusColor: *foreground
        menu:
          fgColor: *foreground
          keyColor: *magenta
          numKeyColor: *magenta
        crumbs:
          fgColor: white
          bgColor: *cyan
          activeColor: *yellow
        status:
          newColor: *cyan
          modifyColor: *blue
          addColor: *green
          errorColor: *red
          highlightcolor: *orange
          killColor: *comment
          completedColor: *comment
        title:
          fgColor: *foreground
          bgColor: *background
          highlightColor: *blue
          counterColor: *magenta
          filterColor: *magenta
      views:
        charts:
          bgColor: default
          defaultDialColors:
            - *blue
            - *red
          defaultChartColors:
            - *blue
            - *red
        table:
          fgColor: *foreground
          bgColor: *background
          cursorFgColor: white
          cursorBgColor: *background
          markColor: darkgoldenrod
          header:
            fgColor: *foreground
            bgColor: *background
            sorterColor: *cyan
        xray:
          fgColor: *foreground
          bgColor: *background
          cursorColor: *current_line
          graphicColor: *blue
          showIcons: false
        yaml:
          keyColor: *magenta
          colonColor: *blue
          valueColor: *foreground
        logs:
          fgColor: *foreground
          bgColor: *background
          indicator:
            fgColor: *foreground
            bgColor: *selection
  '';
}
