{ pkgs, ... }:

{
  programs.niri.enable = true;
  programs.dconf.enable = true;

  environment.variables.SUDO_ASKPASS = pkgs.writeShellScript "askpass" "${pkgs.zenity}/bin/zenity --password --title='sudo Password'";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };
}
