{ ... }:

{
  home.stateVersion = "26.05";

  home.file.".cargo/config.toml".text = ''
    [source.crates-io]
    replace-with = "tuna"

    [source.tuna]
    registry = "sparse+https://mirrors.tuna.tsinghua.edu.cn/crates.io-index/"
  '';

  imports = [
    ./shell.nix
    ./packages.nix
    ./git.nix
    ./appearance.nix
    ./waybar.nix
    ./alacritty.nix
    ./niri.nix
    ./swaybg.nix
    ./rclone.nix
  ];
}
