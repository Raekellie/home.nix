{pkgs, ...}: {
  imports = [
    ./mariadb.nix
  ];
  services.pufferpanel = {
    enable = true;
    # https://search.nixos.org/options?channel=26.05&query=pufferpanel&type=options#show=option%253Aservices.pufferpanel.environment
    # > To create the initial administrator user, run `pufferpanel --workDir /var/lib/pufferpanel user add --admin`
    # Later on, try to figure out if I can just add a oneshot systemd service to run this command (would only work if
    # pufferpanel prevents duplication)
    environment = {
      PUFFER_PANEL_DATABASE_DIALECT = "mysql";
      PUFFER_PANEL_DATABASE_URL = ""; # FIXME: URL to MariaDB via socket authentication
      PUFFER_PANEL_REGISTRATIONENABLED = false;
    };

    extraPackages = [
      pkgs.jre_headless
    ];
  };

  services.mysql = {
    ensureUsers = [
      {
        name = "pufferpanel";
        ensurePermissions = {"pufferpanel.*" = "ALL PRIVILEGES";};
      }
    ];
    ensureDatabases = ["pufferpanel"];
  };
}
