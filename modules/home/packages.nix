{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    keepassxc
    seahorse
    pavucontrol
    rustdesk-flutter
    zed-editor
  ];
}
