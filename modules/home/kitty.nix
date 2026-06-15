{ ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = -1;
      window_padding_width = 8;
      cursor_trail = 50;
      confirm_os_window_close = 0;
    };
  };
}
