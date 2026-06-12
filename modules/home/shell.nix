{ ... }:

{
  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "z" ];
    };
  };

  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
  };
}
