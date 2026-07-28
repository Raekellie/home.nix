{pkgs, ...}: {
  home = {
    shell.enableShellIntegration = true;
    shellAliases = {
      # These aren't loaded, for some reason
      #"nixalias" = "nixos-rebuild --sudo --flake $HOME/dev/nix/home.nix";
      #"nixalias-dev" = "nixalias --override-input dotfiles $HOME/dev/nix/dotfiles";
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
