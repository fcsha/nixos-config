{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    maple-mono.NF-CN
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Noto Sans CJK SC" ];
    monospace = [ "Maple Mono NF CN" ];
  };
}
