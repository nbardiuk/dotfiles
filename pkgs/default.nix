{ self, inputs, pkgs, ... }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // {
    inherit self inputs mypkgs;
  });

  writeBb = name: { content, deps ? [ ] }:
    (pkgs.writers.makeScriptWriter
      { interpreter = "${pkgs.babashka}/bin/bb"; }
      "/bin/${name}"
      content
    ).overrideAttrs (old: { buildInputs = deps; });

  mypkgs = {
    dbeaver-ce = callPackage ./dbeaver.nix { };

    connection_toggle = writeBb "connection-toggle" {
      content = ./connection-toggle.clj;
      deps = [ pkgs.rofi pkgs.networkmanager ];
    };

    keyboard_toggle =
      writeBb "keyboard-toggle" {
        content = ./keyboard-toggle.clj;
        deps = [ pkgs.rofi ];
      };

    open_book = writeBb "open-book" {
      content = ./open-book.clj;
      deps = [ pkgs.rofi pkgs.zathura ];
    };

    review-pr = writeBb "review-pr" {
      content = ./review-pr.clj;
      deps = [ ];
    };
  };

in
mypkgs
