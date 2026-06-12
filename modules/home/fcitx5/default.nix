{ pkgs, ... }:

{
  xdg.dataFile."fcitx5/themes/minami" = {
    source = "${pkgs.fetchFromGitHub {
      owner = "Passthem-desu";
      repo = "fcitx5-theme-pt-cute-light";
      rev = "7cd3c7f61d4c3341cd8bc8337cba777a681789ba";
      sha256 = "0cr1ci8658h2zfidswk9vn5vcz786117xh4713ckywllngbm79k9";
    }}/minami";
  };

  xdg.configFile."fcitx5/config".source = ./config;
  xdg.configFile."fcitx5/conf/classicui.conf".source = ./classicui.conf;
}
