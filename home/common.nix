{config, ...}: {
  imports = [
    ./dotfiles.nix
    ./shell.nix
  ];
  xdg.enable = true;

  nix = {
    assumeXdg = true;
    extraOptions = ''
      !include ${config.sops.secrets.nixAccessTokens.path}
    '';
  };

  # Read the docs/release notes before changing this value
  # (https://nix-community.github.io/home-manager/release-notes.xhtml)
  home.stateVersion = "26.05";
}
