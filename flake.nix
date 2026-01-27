{
  description = "Robin's NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, zen-browser, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.home = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit zen-browser;
      };

      modules = [
        ./configuration.nix
      ];
    };
  };
}

