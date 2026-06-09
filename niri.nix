{ config, pkgs, ... }:
{
  programs.niri = {
    package = pkgs.niri;

    settings = {
      prefer-no-csd = true;

      input = {
        keyboard.numlock = true;
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
      };

      layout = {
        gaps = 16;
        center-focused-column = "never";
        default-column-width.proportion = 0.5;
        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];
        focus-ring = {
          width = 4;
          active.color = "#7fc8ff";
          inactive.color = "#505050";
        };
        border.enable = false;
        shadow = {
          enable = false;
          softness = 30;
          spread = 5;
          offset = {
            x = 0;
            y = 5;
          };
          color = "#0007";
        };
      };

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 0.0;
            top-right = 0.0;
            bottom-right = 0.0;
            bottom-left = 0.0;
          };
          clip-to-geometry = true;
        }
        {
          matches = [ { app-id = ''^org\.wezfurlong\.wezterm$''; } ];
          default-column-width = { };
        }
        {
          matches = [ { app-id = ''firefox$''; title = "^Picture-in-Picture$"; } ];
          open-floating = true;
        }
      ];

      binds = {
        "Mod+Shift+Slash" = { hotkey-overlay.title = "显示快捷键帮助"; action.show-hotkey-overlay = [ ]; };

        "Mod+T" = {
          hotkey-overlay.title = "打开终端：alacritty";
          action.spawn = "alacritty";
        };
        "Mod+D" = {
          hotkey-overlay.title = "启动应用：fuzzel";
          action.spawn = "fuzzel";
        };
        "Super+Alt+L" = {
          hotkey-overlay.title = "锁定屏幕：swaylock";
          action.spawn = [
            "swaylock"
            "--image"
            "${config.home.homeDirectory}/nixos-config/wallpapers/世界很温柔—《龙族》上杉绘梨衣.png"
            "--scaling"
            "fill"
            "--clock"
            "--timestr"
            "%H:%M"
            "--datestr"
            "%Y-%m-%d"
            "--color"
            "1e1e2e"
            "--indicator-radius"
            "100"
            "--indicator-thickness"
            "8"
            "--text-color"
            "cdd6f4"
            "--ring-color"
            "89b4fa"
            "--inside-color"
            "00000000"
            "--line-color"
            "00000000"
            "--separator-color"
            "00000000"
            "--key-hl-color"
            "a6e3a1"
            "--bs-hl-color"
            "f38ba8"
            "--ring-ver-color"
            "f9e2af"
            "--ring-wrong-color"
            "f38ba8"
          ];
        };
        "Super+Alt+S" = {
          allow-when-locked = true;
          hotkey-overlay.hidden = true;
          action.spawn-sh = "pkill orca || exec orca";
        };

        "XF86AudioRaiseVolume" = { allow-when-locked = true; action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; };
        "XF86AudioLowerVolume" = { allow-when-locked = true; action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; };
        "XF86AudioMute" = { allow-when-locked = true; action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; };
        "XF86AudioMicMute" = { allow-when-locked = true; action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; };
        "XF86AudioPlay" = { allow-when-locked = true; action.spawn-sh = "playerctl play-pause"; };
        "XF86AudioStop" = { allow-when-locked = true; action.spawn-sh = "playerctl stop"; };
        "XF86AudioPrev" = { allow-when-locked = true; action.spawn-sh = "playerctl previous"; };
        "XF86AudioNext" = { allow-when-locked = true; action.spawn-sh = "playerctl next"; };
        "XF86MonBrightnessUp" = { allow-when-locked = true; action.spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ]; };
        "XF86MonBrightnessDown" = { allow-when-locked = true; action.spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ]; };

        "Mod+O" = { repeat = false; hotkey-overlay.title = "打开概览"; action.toggle-overview = [ ]; };
        "Mod+Q" = { repeat = false; hotkey-overlay.title = "关闭当前窗口"; action.close-window = [ ]; };

        "Mod+Left" = { hotkey-overlay.title = "聚焦左侧列"; action.focus-column-left = [ ]; };
        "Mod+Down".action.focus-window-down = [ ];
        "Mod+Up".action.focus-window-up = [ ];
        "Mod+Right" = { hotkey-overlay.title = "聚焦右侧列"; action.focus-column-right = [ ]; };
        "Mod+H" = { hotkey-overlay.title = "聚焦左侧列"; action.focus-column-left = [ ]; };
        "Mod+J".action.focus-window-down = [ ];
        "Mod+K".action.focus-window-up = [ ];
        "Mod+L" = { hotkey-overlay.title = "聚焦右侧列"; action.focus-column-right = [ ]; };

        "Mod+Ctrl+Left" = { hotkey-overlay.title = "向左移动列"; action.move-column-left = [ ]; };
        "Mod+Ctrl+Down".action.move-window-down = [ ];
        "Mod+Ctrl+Up".action.move-window-up = [ ];
        "Mod+Ctrl+Right" = { hotkey-overlay.title = "向右移动列"; action.move-column-right = [ ]; };
        "Mod+Ctrl+H" = { hotkey-overlay.title = "向左移动列"; action.move-column-left = [ ]; };
        "Mod+Ctrl+J".action.move-window-down = [ ];
        "Mod+Ctrl+K".action.move-window-up = [ ];
        "Mod+Ctrl+L" = { hotkey-overlay.title = "向右移动列"; action.move-column-right = [ ]; };

        "Mod+Home".action.focus-column-first = [ ];
        "Mod+End".action.focus-column-last = [ ];
        "Mod+Ctrl+Home".action.move-column-to-first = [ ];
        "Mod+Ctrl+End".action.move-column-to-last = [ ];

        "Mod+Shift+Left".action.focus-monitor-left = [ ];
        "Mod+Shift+Down".action.focus-monitor-down = [ ];
        "Mod+Shift+Up".action.focus-monitor-up = [ ];
        "Mod+Shift+Right".action.focus-monitor-right = [ ];
        "Mod+Shift+H".action.focus-monitor-left = [ ];
        "Mod+Shift+J".action.focus-monitor-down = [ ];
        "Mod+Shift+K".action.focus-monitor-up = [ ];
        "Mod+Shift+L".action.focus-monitor-right = [ ];

        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];

        "Mod+Page_Down" = { hotkey-overlay.title = "切换到下一个工作区"; action.focus-workspace-down = [ ]; };
        "Mod+Page_Up" = { hotkey-overlay.title = "切换到上一个工作区"; action.focus-workspace-up = [ ]; };
        "Mod+U" = { hotkey-overlay.title = "切换到下一个工作区"; action.focus-workspace-down = [ ]; };
        "Mod+I" = { hotkey-overlay.title = "切换到上一个工作区"; action.focus-workspace-up = [ ]; };
        "Mod+Ctrl+Page_Down" = { hotkey-overlay.title = "移动列到下一个工作区"; action.move-column-to-workspace-down = [ ]; };
        "Mod+Ctrl+Page_Up" = { hotkey-overlay.title = "移动列到上一个工作区"; action.move-column-to-workspace-up = [ ]; };
        "Mod+Ctrl+U" = { hotkey-overlay.title = "移动列到下一个工作区"; action.move-column-to-workspace-down = [ ]; };
        "Mod+Ctrl+I" = { hotkey-overlay.title = "移动列到上一个工作区"; action.move-column-to-workspace-up = [ ]; };
        "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
        "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
        "Mod+Shift+U".action.move-workspace-down = [ ];
        "Mod+Shift+I".action.move-workspace-up = [ ];

        "Mod+WheelScrollDown" = { cooldown-ms = 150; action.focus-workspace-down = [ ]; };
        "Mod+WheelScrollUp" = { cooldown-ms = 150; action.focus-workspace-up = [ ]; };
        "Mod+Ctrl+WheelScrollDown" = { cooldown-ms = 150; action.move-column-to-workspace-down = [ ]; };
        "Mod+Ctrl+WheelScrollUp" = { cooldown-ms = 150; action.move-column-to-workspace-up = [ ]; };
        "Mod+WheelScrollRight".action.focus-column-right = [ ];
        "Mod+WheelScrollLeft".action.focus-column-left = [ ];
        "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];
        "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
        "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
        "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
        "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+BracketLeft" = { hotkey-overlay.title = "向左吸收或挤出窗口"; action.consume-or-expel-window-left = [ ]; };
        "Mod+BracketRight" = { hotkey-overlay.title = "向右吸收或挤出窗口"; action.consume-or-expel-window-right = [ ]; };
        "Mod+Comma".action.consume-window-into-column = [ ];
        "Mod+Period".action.expel-window-from-column = [ ];
        "Mod+R" = { hotkey-overlay.title = "切换预设列宽"; action.switch-preset-column-width = [ ]; };
        "Mod+Shift+R".action.switch-preset-column-width-back = [ ];
        "Mod+Ctrl+Shift+R".action.switch-preset-window-height = [ ];
        "Mod+Ctrl+R".action.reset-window-height = [ ];
        "Mod+F" = { hotkey-overlay.title = "最大化列"; action.maximize-column = [ ]; };
        "Mod+Shift+F".action.fullscreen-window = [ ];
        "Mod+M".action.maximize-window-to-edges = [ ];
        "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];
        "Mod+C".action.center-column = [ ];
        "Mod+Ctrl+C".action.center-visible-columns = [ ];
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+V" = { hotkey-overlay.title = "在浮动和平铺之间移动窗口"; action.toggle-window-floating = [ ]; };
        "Mod+Shift+V" = { hotkey-overlay.title = "切换浮动/平铺焦点"; action.switch-focus-between-floating-and-tiling = [ ]; };
        "Mod+W".action.toggle-column-tabbed-display = [ ];

        "Print" = { hotkey-overlay.title = "截图"; action.screenshot = [ ]; };
        "Ctrl+Print".action.screenshot-screen = [ ];
        "Alt+Print".action.screenshot-window = [ ];
        "Mod+Escape" = { allow-inhibiting = false; action.toggle-keyboard-shortcuts-inhibit = [ ]; };
        "Mod+Shift+E" = { hotkey-overlay.title = "退出 niri"; action.quit = [ ]; };
        "Ctrl+Alt+Delete".action.quit = [ ];
        "Mod+Shift+P".action.power-off-monitors = [ ];
      };
    };
  };
}
