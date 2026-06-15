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
    llm-agents.url = "github:numtide/llm-agents.nix/79c5475ab35aeff92e6390d7e02c638a84ec4898";
  };

  outputs = { nixpkgs, home-manager, niri, rust-overlay, llm-agents, ... }:
  let
    rustOverlay = final: prev: {
      rust-bin = rust-overlay.lib.mkRustBin {
        distRoot = "https://mirrors.tuna.tsinghua.edu.cn/rustup/dist";
      } final;
    };

    commonModules = [
      ./modules/system
      { nixpkgs.overlays = [ rustOverlay ]; }
      { _module.args.inputs = { inherit llm-agents; }; }
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.sharedModules = [ niri.homeModules.config ];
        home-manager.users.fc = import ./modules/home;
      }
    ];
  in {
    nixosConfigurations.vmware = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = commonModules ++ [ ./hosts/vmware ];
    };

    nixosConfigurations.yoga = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = commonModules ++ [ ./hosts/yoga ];
    };
  };
}
