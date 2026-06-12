{ ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  programs.gnupg.agent = {
    enable = true;
  };

  services.openssh.enable = true;
}
