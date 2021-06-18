final: previous:
with final;
{
  writeBb = name: { content, deps ? [ ] }:
    (writers.makeScriptWriter
      { interpreter = "${pkgs.babashka}/bin/bb"; }
      "/bin/${name}"
      content
    ).overrideAttrs (old: rec {
      buildInputs = deps;
    });
}
