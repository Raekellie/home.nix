{...}: {
  services = {
    zabbixServer = {
      enable = true;
    };
    zabbixWeb = {
      enable = true;
    };
    zabbixAgent = {
      enable = true;
      server = "localhost";
    };
  };
}
