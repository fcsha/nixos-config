{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;

  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
