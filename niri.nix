{ pkgs, ... }:
{
  programs.niri = {
    package = pkgs.niri;

    settings = {
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

      spawn-at-startup = [
        { command = [ "waybar" ]; }
      ];

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      window-rules = [
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
        "Mod+Shift+Slash" = {
          hotkey-overlay.title = "显示快捷键帮助";
          action.show-hotkey-overlay = [ ];
        };

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
          action.spawn = "swaylock";
        };
        "Super+Alt+S" = {
          allow-when-locked = true;
          hotkey-overlay.hidden = true;
          action.spawn-sh = "pkill orca || exec orca";
        };

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          hotkey-overlay.title = "提高音量";
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          hotkey-overlay.title = "降低音量";
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          hotkey-overlay.title = "切换静音";
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          hotkey-overlay.title = "切换麦克风静音";
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          hotkey-overlay.title = "播放/暂停媒体";
          action.spawn-sh = "playerctl play-pause";
        };
        "XF86AudioStop" = {
          allow-when-locked = true;
          hotkey-overlay.title = "停止媒体播放";
          action.spawn-sh = "playerctl stop";
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          hotkey-overlay.title = "上一首媒体";
          action.spawn-sh = "playerctl previous";
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          hotkey-overlay.title = "下一首媒体";
          action.spawn-sh = "playerctl next";
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          hotkey-overlay.title = "提高屏幕亮度";
          action.spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ];
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          hotkey-overlay.title = "降低屏幕亮度";
          action.spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ];
        };

        "Mod+O" = {
          repeat = false;
          hotkey-overlay.title = "切换概览";
          action.toggle-overview = [ ];
        };
        "Mod+Q" = {
          repeat = false;
          hotkey-overlay.title = "关闭窗口";
          action.close-window = [ ];
        };

        "Mod+Left" = { hotkey-overlay.title = "聚焦左侧列"; action.focus-column-left = [ ]; };
        "Mod+Down" = { hotkey-overlay.title = "聚焦下方窗口"; action.focus-window-down = [ ]; };
        "Mod+Up" = { hotkey-overlay.title = "聚焦上方窗口"; action.focus-window-up = [ ]; };
        "Mod+Right" = { hotkey-overlay.title = "聚焦右侧列"; action.focus-column-right = [ ]; };
        "Mod+H" = { hotkey-overlay.title = "聚焦左侧列"; action.focus-column-left = [ ]; };
        "Mod+J" = { hotkey-overlay.title = "聚焦下方窗口"; action.focus-window-down = [ ]; };
        "Mod+K" = { hotkey-overlay.title = "聚焦上方窗口"; action.focus-window-up = [ ]; };
        "Mod+L" = { hotkey-overlay.title = "聚焦右侧列"; action.focus-column-right = [ ]; };

        "Mod+Ctrl+Left" = { hotkey-overlay.title = "向左移动列"; action.move-column-left = [ ]; };
        "Mod+Ctrl+Down" = { hotkey-overlay.title = "向下移动窗口"; action.move-window-down = [ ]; };
        "Mod+Ctrl+Up" = { hotkey-overlay.title = "向上移动窗口"; action.move-window-up = [ ]; };
        "Mod+Ctrl+Right" = { hotkey-overlay.title = "向右移动列"; action.move-column-right = [ ]; };
        "Mod+Ctrl+H" = { hotkey-overlay.title = "向左移动列"; action.move-column-left = [ ]; };
        "Mod+Ctrl+J" = { hotkey-overlay.title = "向下移动窗口"; action.move-window-down = [ ]; };
        "Mod+Ctrl+K" = { hotkey-overlay.title = "向上移动窗口"; action.move-window-up = [ ]; };
        "Mod+Ctrl+L" = { hotkey-overlay.title = "向右移动列"; action.move-column-right = [ ]; };

        "Mod+Home" = { hotkey-overlay.title = "聚焦第一列"; action.focus-column-first = [ ]; };
        "Mod+End" = { hotkey-overlay.title = "聚焦最后一列"; action.focus-column-last = [ ]; };
        "Mod+Ctrl+Home" = { hotkey-overlay.title = "移动列到最前"; action.move-column-to-first = [ ]; };
        "Mod+Ctrl+End" = { hotkey-overlay.title = "移动列到最后"; action.move-column-to-last = [ ]; };

        "Mod+Shift+Left" = { hotkey-overlay.title = "聚焦左侧显示器"; action.focus-monitor-left = [ ]; };
        "Mod+Shift+Down" = { hotkey-overlay.title = "聚焦下方显示器"; action.focus-monitor-down = [ ]; };
        "Mod+Shift+Up" = { hotkey-overlay.title = "聚焦上方显示器"; action.focus-monitor-up = [ ]; };
        "Mod+Shift+Right" = { hotkey-overlay.title = "聚焦右侧显示器"; action.focus-monitor-right = [ ]; };
        "Mod+Shift+H" = { hotkey-overlay.title = "聚焦左侧显示器"; action.focus-monitor-left = [ ]; };
        "Mod+Shift+J" = { hotkey-overlay.title = "聚焦下方显示器"; action.focus-monitor-down = [ ]; };
        "Mod+Shift+K" = { hotkey-overlay.title = "聚焦上方显示器"; action.focus-monitor-up = [ ]; };
        "Mod+Shift+L" = { hotkey-overlay.title = "聚焦右侧显示器"; action.focus-monitor-right = [ ]; };

        "Mod+Shift+Ctrl+Left" = { hotkey-overlay.title = "移动列到左侧显示器"; action.move-column-to-monitor-left = [ ]; };
        "Mod+Shift+Ctrl+Down" = { hotkey-overlay.title = "移动列到下方显示器"; action.move-column-to-monitor-down = [ ]; };
        "Mod+Shift+Ctrl+Up" = { hotkey-overlay.title = "移动列到上方显示器"; action.move-column-to-monitor-up = [ ]; };
        "Mod+Shift+Ctrl+Right" = { hotkey-overlay.title = "移动列到右侧显示器"; action.move-column-to-monitor-right = [ ]; };
        "Mod+Shift+Ctrl+H" = { hotkey-overlay.title = "移动列到左侧显示器"; action.move-column-to-monitor-left = [ ]; };
        "Mod+Shift+Ctrl+J" = { hotkey-overlay.title = "移动列到下方显示器"; action.move-column-to-monitor-down = [ ]; };
        "Mod+Shift+Ctrl+K" = { hotkey-overlay.title = "移动列到上方显示器"; action.move-column-to-monitor-up = [ ]; };
        "Mod+Shift+Ctrl+L" = { hotkey-overlay.title = "移动列到右侧显示器"; action.move-column-to-monitor-right = [ ]; };

        "Mod+Page_Down" = { hotkey-overlay.title = "聚焦下一个工作区"; action.focus-workspace-down = [ ]; };
        "Mod+Page_Up" = { hotkey-overlay.title = "聚焦上一个工作区"; action.focus-workspace-up = [ ]; };
        "Mod+U" = { hotkey-overlay.title = "聚焦下一个工作区"; action.focus-workspace-down = [ ]; };
        "Mod+I" = { hotkey-overlay.title = "聚焦上一个工作区"; action.focus-workspace-up = [ ]; };
        "Mod+Ctrl+Page_Down" = { hotkey-overlay.title = "移动列到下一个工作区"; action.move-column-to-workspace-down = [ ]; };
        "Mod+Ctrl+Page_Up" = { hotkey-overlay.title = "移动列到上一个工作区"; action.move-column-to-workspace-up = [ ]; };
        "Mod+Ctrl+U" = { hotkey-overlay.title = "移动列到下一个工作区"; action.move-column-to-workspace-down = [ ]; };
        "Mod+Ctrl+I" = { hotkey-overlay.title = "移动列到上一个工作区"; action.move-column-to-workspace-up = [ ]; };
        "Mod+Shift+Page_Down" = { hotkey-overlay.title = "向下移动工作区"; action.move-workspace-down = [ ]; };
        "Mod+Shift+Page_Up" = { hotkey-overlay.title = "向上移动工作区"; action.move-workspace-up = [ ]; };
        "Mod+Shift+U" = { hotkey-overlay.title = "向下移动工作区"; action.move-workspace-down = [ ]; };
        "Mod+Shift+I" = { hotkey-overlay.title = "向上移动工作区"; action.move-workspace-up = [ ]; };

        "Mod+WheelScrollDown" = { cooldown-ms = 150; hotkey-overlay.title = "滚轮切到下一个工作区"; action.focus-workspace-down = [ ]; };
        "Mod+WheelScrollUp" = { cooldown-ms = 150; hotkey-overlay.title = "滚轮切到上一个工作区"; action.focus-workspace-up = [ ]; };
        "Mod+Ctrl+WheelScrollDown" = { cooldown-ms = 150; hotkey-overlay.title = "滚轮移动列到下一个工作区"; action.move-column-to-workspace-down = [ ]; };
        "Mod+Ctrl+WheelScrollUp" = { cooldown-ms = 150; hotkey-overlay.title = "滚轮移动列到上一个工作区"; action.move-column-to-workspace-up = [ ]; };
        "Mod+WheelScrollRight" = { hotkey-overlay.title = "滚轮聚焦右侧列"; action.focus-column-right = [ ]; };
        "Mod+WheelScrollLeft" = { hotkey-overlay.title = "滚轮聚焦左侧列"; action.focus-column-left = [ ]; };
        "Mod+Ctrl+WheelScrollRight" = { hotkey-overlay.title = "滚轮向右移动列"; action.move-column-right = [ ]; };
        "Mod+Ctrl+WheelScrollLeft" = { hotkey-overlay.title = "滚轮向左移动列"; action.move-column-left = [ ]; };
        "Mod+Shift+WheelScrollDown" = { hotkey-overlay.title = "滚轮聚焦右侧列"; action.focus-column-right = [ ]; };
        "Mod+Shift+WheelScrollUp" = { hotkey-overlay.title = "滚轮聚焦左侧列"; action.focus-column-left = [ ]; };
        "Mod+Ctrl+Shift+WheelScrollDown" = { hotkey-overlay.title = "滚轮向右移动列"; action.move-column-right = [ ]; };
        "Mod+Ctrl+Shift+WheelScrollUp" = { hotkey-overlay.title = "滚轮向左移动列"; action.move-column-left = [ ]; };

        "Mod+1" = { hotkey-overlay.title = "聚焦工作区 1"; action.focus-workspace = 1; };
        "Mod+2" = { hotkey-overlay.title = "聚焦工作区 2"; action.focus-workspace = 2; };
        "Mod+3" = { hotkey-overlay.title = "聚焦工作区 3"; action.focus-workspace = 3; };
        "Mod+4" = { hotkey-overlay.title = "聚焦工作区 4"; action.focus-workspace = 4; };
        "Mod+5" = { hotkey-overlay.title = "聚焦工作区 5"; action.focus-workspace = 5; };
        "Mod+6" = { hotkey-overlay.title = "聚焦工作区 6"; action.focus-workspace = 6; };
        "Mod+7" = { hotkey-overlay.title = "聚焦工作区 7"; action.focus-workspace = 7; };
        "Mod+8" = { hotkey-overlay.title = "聚焦工作区 8"; action.focus-workspace = 8; };
        "Mod+9" = { hotkey-overlay.title = "聚焦工作区 9"; action.focus-workspace = 9; };
        "Mod+Ctrl+1" = { hotkey-overlay.title = "移动列到工作区 1"; action.move-column-to-workspace = 1; };
        "Mod+Ctrl+2" = { hotkey-overlay.title = "移动列到工作区 2"; action.move-column-to-workspace = 2; };
        "Mod+Ctrl+3" = { hotkey-overlay.title = "移动列到工作区 3"; action.move-column-to-workspace = 3; };
        "Mod+Ctrl+4" = { hotkey-overlay.title = "移动列到工作区 4"; action.move-column-to-workspace = 4; };
        "Mod+Ctrl+5" = { hotkey-overlay.title = "移动列到工作区 5"; action.move-column-to-workspace = 5; };
        "Mod+Ctrl+6" = { hotkey-overlay.title = "移动列到工作区 6"; action.move-column-to-workspace = 6; };
        "Mod+Ctrl+7" = { hotkey-overlay.title = "移动列到工作区 7"; action.move-column-to-workspace = 7; };
        "Mod+Ctrl+8" = { hotkey-overlay.title = "移动列到工作区 8"; action.move-column-to-workspace = 8; };
        "Mod+Ctrl+9" = { hotkey-overlay.title = "移动列到工作区 9"; action.move-column-to-workspace = 9; };

        "Mod+BracketLeft" = { hotkey-overlay.title = "向左吸收或挤出窗口"; action.consume-or-expel-window-left = [ ]; };
        "Mod+BracketRight" = { hotkey-overlay.title = "向右吸收或挤出窗口"; action.consume-or-expel-window-right = [ ]; };
        "Mod+Comma" = { hotkey-overlay.title = "把窗口吸收到列中"; action.consume-window-into-column = [ ]; };
        "Mod+Period" = { hotkey-overlay.title = "从列中挤出窗口"; action.expel-window-from-column = [ ]; };
        "Mod+R" = { hotkey-overlay.title = "切换预设列宽"; action.switch-preset-column-width = [ ]; };
        "Mod+Shift+R" = { hotkey-overlay.title = "反向切换预设列宽"; action.switch-preset-column-width-back = [ ]; };
        "Mod+Ctrl+Shift+R" = { hotkey-overlay.title = "切换预设窗口高度"; action.switch-preset-window-height = [ ]; };
        "Mod+Ctrl+R" = { hotkey-overlay.title = "重置窗口高度"; action.reset-window-height = [ ]; };
        "Mod+F" = { hotkey-overlay.title = "最大化列"; action.maximize-column = [ ]; };
        "Mod+Shift+F" = { hotkey-overlay.title = "窗口全屏"; action.fullscreen-window = [ ]; };
        "Mod+M" = { hotkey-overlay.title = "窗口最大化到边缘"; action.maximize-window-to-edges = [ ]; };
        "Mod+Ctrl+F" = { hotkey-overlay.title = "扩展列到可用宽度"; action.expand-column-to-available-width = [ ]; };
        "Mod+C" = { hotkey-overlay.title = "居中当前列"; action.center-column = [ ]; };
        "Mod+Ctrl+C" = { hotkey-overlay.title = "居中可见列"; action.center-visible-columns = [ ]; };
        "Mod+Minus" = { hotkey-overlay.title = "减小列宽"; action.set-column-width = "-10%"; };
        "Mod+Equal" = { hotkey-overlay.title = "增大列宽"; action.set-column-width = "+10%"; };
        "Mod+Shift+Minus" = { hotkey-overlay.title = "减小窗口高度"; action.set-window-height = "-10%"; };
        "Mod+Shift+Equal" = { hotkey-overlay.title = "增大窗口高度"; action.set-window-height = "+10%"; };
        "Mod+V" = { hotkey-overlay.title = "切换窗口浮动"; action.toggle-window-floating = [ ]; };
        "Mod+Shift+V" = { hotkey-overlay.title = "在浮动和平铺焦点间切换"; action.switch-focus-between-floating-and-tiling = [ ]; };
        "Mod+W" = { hotkey-overlay.title = "切换列标签页显示"; action.toggle-column-tabbed-display = [ ]; };

        "Print" = { hotkey-overlay.title = "截图"; action.screenshot = [ ]; };
        "Ctrl+Print" = { hotkey-overlay.title = "截取屏幕"; action.screenshot-screen = [ ]; };
        "Alt+Print" = { hotkey-overlay.title = "截取窗口"; action.screenshot-window = [ ]; };
        "Mod+Escape" = {
          allow-inhibiting = false;
          hotkey-overlay.title = "切换键盘快捷键抑制";
          action.toggle-keyboard-shortcuts-inhibit = [ ];
        };
        "Mod+Shift+E" = { hotkey-overlay.title = "退出 niri"; action.quit = [ ]; };
        "Ctrl+Alt+Delete" = { hotkey-overlay.title = "退出 niri"; action.quit = [ ]; };
        "Mod+Shift+P" = { hotkey-overlay.title = "关闭显示器电源"; action.power-off-monitors = [ ]; };
      };
    };
  };
}
