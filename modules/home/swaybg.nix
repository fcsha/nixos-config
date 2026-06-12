{ config, pkgs, ... }:

{
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${config.home.homeDirectory}/nixos-config/assets/wallpapers/世界很温柔—《龙族》上杉绘梨衣.png -m fill";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
