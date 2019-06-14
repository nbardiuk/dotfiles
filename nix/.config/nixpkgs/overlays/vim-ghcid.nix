final: previous:
let
  revision = "b38d16bae64e036063650279d2811d13368b5b55";
  vim-ghcid = final.vimUtils.buildVimPlugin {
    pname = "ghcid";
    version = revision;
    src = final.fetchFromGitHub {
      owner = "ndmitchell";
      repo = "ghcid";
      rev = revision;
      sha256 = "083d12cp4cldlmc0fqxj3j4xpa9azgbbd2392s7b9pp6rjk0gcjn";
    };
    configurePhase = "cd plugins/nvim";
  };
in {
  inherit vim-ghcid;
}
