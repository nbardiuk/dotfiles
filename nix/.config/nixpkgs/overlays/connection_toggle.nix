final: previous:
let
  writeBabashka = name: final.writers.makeScriptWriter
    { interpreter = "${final.pkgs.babashka}/bin/bb"; }
    "/bin/${name}";
in
{
  connection_toggle = (writeBabashka
    "connection-toggle.clj"
    (builtins.readFile ./connection-toggle.clj)
  ).overrideAttrs (old: rec {
    buildInputs = [ final.rofi final.networkmanager ];
  });
}
