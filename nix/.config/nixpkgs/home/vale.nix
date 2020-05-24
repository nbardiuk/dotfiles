{ pkgs, ... }:
{
  home.file.".vale.ini".text = ''
    # Global settings (applied to every syntax)
    [*]
    BasedOnStyles = proselint, write-good, Joblint
  '';

  home.packages = with pkgs; [
    vale
  ];
}
