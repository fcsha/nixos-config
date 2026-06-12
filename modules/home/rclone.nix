{ config, ... }:

{
  programs.rclone = {
    enable = true;
    remotes.jianguoyun = {
      config = {
        type = "webdav";
        url = "https://dav.jianguoyun.com/dav/";
        vendor = "other";
        user = "fcsha@qq.com";
      };
      secrets = {
        pass = "${config.home.homeDirectory}/.secrets/rclone-jianguoyun-pass";
      };
      mounts."" = {
        enable = true;
        mountPoint = "${config.home.homeDirectory}/jianguoyun";
      };
    };
  };
}
