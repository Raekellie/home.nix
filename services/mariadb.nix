{pkgs, ...}: {
  services.mysql = {
    package = pkgs.mariadb;

    settings = {
      mysqld = {
        # https://mariadb.com/docs/server/server-management/variables-and-modes/server-system-variables#socket
        # I'm setting the (default) value explicitly here so that I can access it declaratively from other Nix modules
        socket = "/tmp/mysql.sock";
      };
    };
  };
}
