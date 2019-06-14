final: previous:
let
  merlin = final.ocamlPackages_latest.merlin;
  vim-merlin = final.vimUtils.buildVimPlugin {
    pname = "merlin";
    version = merlin.version;
    src = merlin.src;
    configurePhase = "cd vim/merlin";
  };
in {
  inherit vim-merlin;
}
