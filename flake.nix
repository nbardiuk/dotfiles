{

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    musnix.url = "github:musnix/musnix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, musnix, home-manager, neovim-nightly-overlay }: {
    nixosConfigurations = {
      tuxer = nixpkgs.lib.nixosSystem
        {
          system = "x86_64-linux";
          modules = [
            musnix.nixosModules.musnix

            ./nixos/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nazarii = import ./nix/.config/home-manager/home.nix;
            }
            # TODO build as packages
            {
              nixpkgs.overlays = [
                (import ./nix/.config/nixpkgs/overlays/beekeeper.nix)
                (import ./nix/.config/nixpkgs/overlays/connection_toggle.nix)
                (import ./nix/.config/nixpkgs/overlays/dbeaver.nix)
                (import ./nix/.config/nixpkgs/overlays/fennel-ls.nix)
                (import ./nix/.config/nixpkgs/overlays/i3blocks-brightness.nix)
                (import ./nix/.config/nixpkgs/overlays/i3blocks-contrib.nix)
                (import ./nix/.config/nixpkgs/overlays/keyboard_toggle.nix)
                (import ./nix/.config/nixpkgs/overlays/open_book.nix)
                (import ./nix/.config/nixpkgs/overlays/review_pr.nix)
                (import ./nix/.config/nixpkgs/overlays/write-babashka.nix)
                neovim-nightly-overlay.overlays.default
              ];
            }
          ];


        };
    };
  };
}
