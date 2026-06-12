{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, niri, rust-overlay, ... }:
  let
    rustOverlay = final: prev: {
      rust-bin = rust-overlay.lib.mkRustBin {
        distRoot = "https://mirrors.tuna.tsinghua.edu.cn/rustup/dist";
      } final;
    };
  in {
    nixosConfigurations.vmware = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hosts/vmware
        { nixpkgs.overlays = [ rustOverlay ]; }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.sharedModules = [ niri.homeModules.config ];
          home-manager.users.fc = import ./home.nix;
        }
      ];
    };

    nixosConfigurations.yoga = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hosts/yoga
        { nixpkgs.overlays = [ rustOverlay ]; }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.sharedModules = [ niri.homeModules.config ];
          home-manager.users.fc = import ./home.nix;
        }
      ];
    };
  };
}
