{
  pkgs,
  config,
  lib,
  ...
}: {
  # TODO: think of a way for each service to append its respective values to this configFile, instead of hardcoding all
  # the stuff here
  services.caddy = {
    enable = true;
    openFirewall = true;
    configFile = pkgs.writeText "Caddyfile" ''
      silverbullet.raquellie.com {
        reverse_proxy localhost:${lib.toString config.services.silverbullet.listenPort}
      }
    '';
  };
}
