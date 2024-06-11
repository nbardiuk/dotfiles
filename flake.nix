{

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    musnix.url = "github:musnix/musnix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    chrisbra-colorizer.flake = false;
    chrisbra-colorizer.url = "git+https://github.com/chrisbra/colorizer";
    co-author.flake = false;
    co-author.url = "git+https://github.com/2KAbhishek/co-author.nvim";
    conjure.flake = false;
    conjure.url = "git+https://github.com/Olical/conjure";
    nfnl.flake = false;
    nfnl.url = "git+https://github.com/Olical/nfnl";
    none-ls.flake = false;
    none-ls.url = "git+https://github.com/nvimtools/none-ls.nvim";
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
  };

  outputs = inputs @ { self, nixpkgs, musnix, home-manager, neovim-nightly-overlay, ... }: {
    nixosConfigurations =
      let
        system = "x86_64-linux";
        mypkgs = import ./pkgs {
          inherit self;
          pkgs = nixpkgs.legacyPackages."${system}";
          inherit inputs;
        };
      in
      {
        tuxer = nixpkgs.lib.nixosSystem
          {
            inherit system;
            modules = [
              musnix.nixosModules.musnix

              ./nixos/configuration.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.nazarii = import ./home-manager/home.nix;
                home-manager.extraSpecialArgs = { inherit inputs; inherit mypkgs; };
              }

              # TODO build as packages
              {
                nixpkgs.overlays = [
                  (import ./nix/.config/nixpkgs/overlays/connection_toggle.nix)
                  (import ./nix/.config/nixpkgs/overlays/keyboard_toggle.nix)
                  (import ./nix/.config/nixpkgs/overlays/open_book.nix)
                  (import ./nix/.config/nixpkgs/overlays/review_pr.nix)
                  (import ./nix/.config/nixpkgs/overlays/write-babashka.nix)
                ];
              }
            ];
          };
      };
  };
}
