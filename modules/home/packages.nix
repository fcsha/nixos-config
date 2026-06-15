{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    keepassxc
    pavucontrol
    rustdesk-flutter
    yazi
    zed-editor
    helix
    neovim
    wechat
    qq
  ];
}
