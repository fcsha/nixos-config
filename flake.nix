{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.fc = { pkgs, ... }: {
            home.stateVersion = "26.05";

            home.packages = with pkgs; [
              pavucontrol
            ];

            programs.git = {
              enable = true;
              package = null;
              settings.user = {
                name = "Fucheng Sha";
                email = "fcsha@qq.com";
              };
            };

            programs.waybar = {
              enable = true;
              settings.mainBar = {
                layer = "top";
                position = "top";
                height = 32;
                spacing = 8;

                modules-left = [ "niri/workspaces" "niri/window" ];
                modules-center = [ "clock" ];
                modules-right = [ "niri/language" "network" "pulseaudio" "battery" "tray" ];

                "niri/workspaces" = {
                  format = "{icon}";
                  format-icons = {
                    active = "";
                    focused = "";
                    default = "";
                  };
                };

                "niri/window" = {
                  format = "{title}";
                  icon = true;
                  icon-size = 18;
                  separate-outputs = true;
                  rewrite = {
                    "(.*) - Mozilla Firefox" = "󰈹 $1";
                    "(.*) - Alacritty" = " $1";
                  };
                };

                "niri/language" = {
                  format = "󰌌 {short}";
                };

                clock = {
                  format = " {:%H:%M}";
                  tooltip-format = "<big>{:%Y-%m-%d}</big>\n<tt><small>{calendar}</small></tt>";
                };

                network = {
                  format-wifi = "󰤨 {essid}";
                  format-ethernet = "󰈀 {ifname}";
                  format-disconnected = "󰤭 disconnected";
                  tooltip-format = "{ifname}: {ipaddr}/{cidr}";
                };

                pulseaudio = {
                  format = "{icon} {volume}%";
                  format-muted = "󰝟 muted";
                  format-icons.default = [ "󰕿" "󰖀" "󰕾" ];
                  on-click = "pavucontrol";
                };

                battery = {
                  format = "{icon} {capacity}%";
                  format-charging = "󰂄 {capacity}%";
                  format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
                };

                tray = {
                  icon-size = 16;
                  spacing = 8;
                };
              };

              systemd = {
                enable = true;
                targets = [ "niri.service" ];
              };

              style = ''
                * {
                  border: none;
                  border-radius: 0;
                  font-family: "Maple Mono NF CN", sans-serif;
                  font-size: 13px;
                  min-height: 0;
                }

                window#waybar {
                  background: rgba(30, 30, 46, 0.92);
                  color: #cdd6f4;
                }

                #workspaces button {
                  padding: 0 6px;
                  color: #6c7086;
                }

                #workspaces button.active,
                #workspaces button.focused {
                  color: #89b4fa;
                }

                #window,
                #clock,
                #language,
                #network,
                #pulseaudio,
                #battery,
                #tray {
                  padding: 0 10px;
                }

                #clock {
                  color: #f9e2af;
                }

                #battery.charging {
                  color: #a6e3a1;
                }

                #battery.warning:not(.charging) {
                  color: #fab387;
                }

                #battery.critical:not(.charging) {
                  color: #f38ba8;
                }
              '';
            };
          };
        }
      ];
    };
  };
}
