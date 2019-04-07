{ newScope, callPackage, stdenv, fetchFromGitHub
, Carbon, Cocoa, ApplicationServices
, imagemagick }:

let

  _cfg = {
    repo = "chunkwm";
    sha256 = "1w11my418fx0k493432nyj1sm1g215rm4pi4xlsg978m7kbwdmiq";
    version = "2f840cd71a3d44c8c543125d7aa9eefa5fae9504";
  };

  self = chunkwm;

  callPackage = newScope self;

  chunkwm = with self; {

    core = callPackage ./core.nix {
      cfg = _cfg // { name = "core"; };
      inherit Carbon Cocoa;
    };

    border = callPackage ./plugin.nix {
      cfg = _cfg // { name = "border"; };
      inherit Carbon Cocoa ApplicationServices;
    };

    ffm = callPackage ./plugin.nix {
      cfg = _cfg // { name = "ffm"; };
      inherit Carbon Cocoa ApplicationServices;
    };

    tiling = callPackage ./plugin.nix {
      cfg = _cfg // { name = "tiling"; };
      inherit Carbon Cocoa ApplicationServices;
    };

    purify = callPackage ./plugin.nix {
      cfg = _cfg // { name = "purify"; };
      inherit Carbon Cocoa ApplicationServices;
    };

  }; in chunkwm
