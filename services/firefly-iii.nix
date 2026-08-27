{...}: {
  imports = [
    ./mariadb.nix
  ];
  services.firefly-iii = {
    enable = true;

    settings = {
      DB_CONNECTION = "mysql";
    };
  };

  services.mysql = {
    ensureUsers = [
      {
        name = "firefly-iii";
        ensurePermissions = {"firefly-iii.*" = "ALL PRIVILEGES";};
      }
    ];
    ensureDatabases = ["firefly-iii"];
  };
}
