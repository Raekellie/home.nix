{pkgs, ...}: {
  home = {
    shellAliases = {
      "nixswitch" = "nixos-rebuild switch --sudo --flake $HOME/dev/nix/home.nix";
      "nixswitch-dev" = "nixswitch --override-input dotfiles $HOME/dev/nix/dotfiles";
    };
  };

  programs = {
    starship.enable = true;
    nushell.enable = true;

    git = {
      enable = true;
      settings = {
        user = {
          name = "Raquel";
          email = "ela@raquellie.com";
        };
        init.defaultBranch = "main";
      };
    };
  };

  home.packages = with pkgs; [];
}
