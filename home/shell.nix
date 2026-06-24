{pkgs, ...}: {
  home = {
    shell.enableShellIntegration = true;
    shellAliases = {
      "nixswitch" = "nixos-rebuild switch --sudo --flake $HOME/dev/nix/home.nix";
      "nixswitch-dev" = "nixswitch --override-input dotfiles $HOME/dev/nix/dotfiles";
    };
  };

  programs = {
    nushell.enable = false;

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
