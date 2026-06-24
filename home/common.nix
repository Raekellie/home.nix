{config, ...}: {
  xdg.enable = true;
  
  nix = {
    assumeXdg = true;
    extraOptions = ''
      !include ${config.sops.secrets.nixAccessTokens.path}
    '';
  };
}
