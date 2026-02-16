{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Raquel";
        email = "dev@raquellie.com";
      };
      init.defaultBranch = "main";
    };
  };

  home.packages = with pkgs; [
  ];

  programs.zsh = {
    shellAliases = {
      "flakeswitch" = "sudo nixos-rebuild switch --flake $HOME/cfg#nixos";
    };
  };
}
