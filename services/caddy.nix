{
  pkgs,
  config,
  lib,
  ...
}: {
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
