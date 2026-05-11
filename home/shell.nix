{ config, pkgs, ... }:

{
  home = {
    shell.enableFishIntegration = true;
    shellAliases = {
      "nixswitch" = "nixos-rebuild switch --sudo --flake ~/dev/nix/home.nix";
      "nixswitch-dev" = "nixswitch --override-input dotfiles ~/dev/nix/dotfiles";
    };
  };

  #programs.vim = {
  #  enable = true;
  #  defaultEditor = true;
  #};

  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.nushell.enable = true;

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
