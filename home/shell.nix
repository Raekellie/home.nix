{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "nixswitch" = "sudo nixos-rebuild switch --flake ~/nixos-config";
    };
  };

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

  home.packages = with pkgs; [ ];
}
