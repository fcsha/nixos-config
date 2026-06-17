{ ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 8;

      modules-left = [ "niri/workspaces" ];
      modules-center = [ "niri/window" ];
      modules-right = [ "tray" "network" "pulseaudio" "battery" "clock" ];

      "niri/workspaces" = {
        format = "{index}";
      };

      "niri/window" = {
        format = "{title}";
        separate-outputs = true;
        rewrite = {
          "(.*) - Mozilla Firefox" = "󰈹 $1";
          "(.*) - Alacritty" = " $1";
        };
      };

      clock = {
        format = " {:%H:%M}";
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

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "Maple Mono NF CN", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(9, 9, 11, 0.8);
        color: #f4f4f5;
      }

      #workspaces {
        margin: 0;
        padding: 0;
      }

      #workspaces button {
        padding: 0;
        margin: 4px 2px;
        min-width: 24px;
        min-height: 24px;
        border-radius: 0;
        color: #71717a;
        background: transparent;
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        background: #3f3f46;
        color: #71717a;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: #fafafa;
        background: #52525b;
        font-weight: bold;
      }

      #workspaces button.active:hover,
      #workspaces button.focused:hover {
        background: #71717a;
        color: #fafafa;
      }

      #window,
      #clock,
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
}
