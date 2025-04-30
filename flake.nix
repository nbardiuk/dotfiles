{

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    chrisbra-colorizer.flake = false;
    chrisbra-colorizer.url = "git+https://github.com/chrisbra/colorizer";

    co-author.flake = false;
    co-author.url = "git+https://github.com/2KAbhishek/co-author.nvim";

    conform.flake = false;
    conform.url = "git+https://github.com/stevearc/conform.nvim";

    conjure.flake = false;
    conjure.url = "git+https://github.com/Olical/conjure";

    nfnl.flake = false;
    nfnl.url = "git+https://github.com/Olical/nfnl";

    none-ls.flake = false;
    # TODO revert when merged https://github.com/nvimtools/none-ls.nvim/pull/277
    none-ls.url = "git+https://github.com/ulisses-cruz/none-ls.nvim";

    nvim-grey.flake = false;
    nvim-grey.url = "git+https://github.com/yorickpeterse/nvim-grey";

    other-nvim.flake = false;
    other-nvim.url = "git+https://github.com/rgroli/other.nvim";

    tsc-nvim.flake = false;
    tsc-nvim.url = "git+https://github.com/dmmulroy/tsc.nvim";

    vim-rest-console.flake = false;
    vim-rest-console.url = "git+https://github.com/diepm/vim-rest-console";

    wiki-vim.flake = false;
    wiki-vim.url = "git+https://github.com/lervag/wiki.vim";

    nixpkgs-betaflight.url = "github:nixos/nixpkgs/c9223ea44c223379f22a091c57700fa378a758df";
  };

  outputs = inputs @ { self, nixpkgs, nix-darwin, musnix, nixos-hardware, home-manager, ... }: {
    nixosConfigurations =
      let
        system = "x86_64-linux";
        mypkgs = import ./pkgs {
          inherit self inputs;
          pkgs = nixpkgs.legacyPackages.${system};
        };
      in
      {
        tuxer = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            musnix.nixosModules.musnix

            nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen7

            ./nixos/configuration.nix

            {
              nixpkgs.overlays = [
                (final: prev: {
                  betaflight-configurator = prev.betaflight-configurator.override {
                    inherit (inputs.nixpkgs-betaflight.legacyPackages.${prev.system}) nwjs;
                  };
                })
                # TODO remove after merge https://github.com/NixOS/nixpkgs/issues/399907
                (final: prev: {
                  qt6Packages = prev.qt6Packages.overrideScope (_: kprev: {
                    qt6gtk2 = kprev.qt6gtk2.overrideAttrs (_: {
                      version = "0.5-unstable-2025-03-04";
                      src = final.fetchFromGitLab {
                        domain = "opencode.net";
                        owner = "trialuser";
                        repo = "qt6gtk2";
                        rev = "d7c14bec2c7a3d2a37cde60ec059fc0ed4efee67";
                        hash = "sha256-6xD0lBiGWC3PXFyM2JW16/sDwicw4kWSCnjnNwUT4PI=";
                      };
                    });
                  });
                })
              ];
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.nazarii = import ./home-manager/home.nix;
              home-manager.extraSpecialArgs = { inherit inputs mypkgs; };
            }
          ];
        };
        tvbox = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-gpu-nvidia-sync
            nixos-hardware.nixosModules.common-pc-laptop
            nixos-hardware.nixosModules.common-pc-laptop-ssd

            ./tvbox/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.nazarii = import ./tvbox/home.nix;
              home-manager.extraSpecialArgs = { inherit inputs mypkgs; };
            }
          ];
        };

      };
    darwinConfigurations =
      let
        system = "aarch64-darwin";
        mypkgs = import ./pkgs {
          inherit self inputs;
          pkgs = nixpkgs.legacyPackages.${system};
        };
      in
      {
        darwin = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.nazarii = import ./darwin/home.nix;
              home-manager.extraSpecialArgs = { inherit inputs mypkgs; };
            }
          ];
        };
      };
  };
}
