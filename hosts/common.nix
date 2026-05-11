{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  # Allow SysRq to be used for process signaling (term, kill, and oom-kill)
  # https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html
  boot.kernel.sysctl."kernel.sysrq" = 64;

  services = {
    openssh = {
      enable = true;

      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    fail2ban.enable = true;
  };
}
