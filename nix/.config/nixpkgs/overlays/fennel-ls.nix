final: previous:
with final;
{
  fennel-ls = pkgs.stdenv.mkDerivation
    rec {
      pname = "fennel-ls";
      version = "fe257c06";

      src = pkgs.fetchFromSourcehut {
        owner = "~xerool";
        repo = pname;
        rev = version;
        sha256 = "sha256-kKeSaRz6AIiZujrxyJaiJ27IBUkoFwiN0MgmiOX5tn0=";
        fetchSubmodules = false;
      };

      buildInputs = with pkgs; [
        lua
      ];

      buildPhase = ''
        patchShebangs fennel
        make
      '';

      dontStrip = true;

      installPhase = ''
        mkdir -p $out/bin
        cp fennel-ls $out/bin
      '';

      meta = with lib; {
        description = "A language server for fennel";
        homepage = "https://git.sr.ht/~xerool/fennel-ls";
        license = licenses.mit;
        platforms = [ "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
      };
    };
}
