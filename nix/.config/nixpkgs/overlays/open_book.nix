final: previous:
let
  writeBabashka = name: final.writers.makeScriptWriter
    { interpreter = "${final.pkgs.babashka}/bin/bb"; }
    "/bin/${name}";
in {
  open_book = (writeBabashka
    "open-book.clj"
    (builtins.readFile ./open-book.clj)
  ).overrideAttrs (old: rec {
    buildInputs = [ final.rofi final.zathura ];
  });
}
