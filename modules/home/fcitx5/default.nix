{ ... }:

{
  xdg.configFile."fcitx5/config".source = ./config;
  xdg.configFile."fcitx5/conf/classicui.conf".source = ./classicui;
  xdg.dataFile."fcitx5/rime/default.custom.yaml".source = ./rime/default.custom.yaml;
  xdg.dataFile."fcitx5/themes/fc/theme.conf".source = ./themes/fc/theme.conf;
}
