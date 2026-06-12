{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    alacritty
    brave
    nautilus
    fastfetch
    opencode
    zenity
    fuzzel
    swaylock-effects
    swaybg
    nodejs_latest
    corepack
    bun
    gcc
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
      extensions = [ "rust-src" ];
    }))
  ];
}
