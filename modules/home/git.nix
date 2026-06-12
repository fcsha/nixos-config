{ ... }:

{
  programs.git = {
    enable = true;
    package = null;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Fucheng Sha";
        email = "fcsha@qq.com";
      };
    };
    signing = {
      key = "2F99B3AF794163DB7E4C1F389932A09BFB70E324";
      signByDefault = true;
    };
  };
}
