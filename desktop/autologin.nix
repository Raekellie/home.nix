{ config, pkgs, ... }:

{
  # https://wiki.nixos.org/wiki/Full_Disk_Encryption#Autologin_using_LUKS_password

  services.displayManager.autoLogin.user = "raquel"; # Not a fan of this hardcoding

  boot.initrd.systemd.enable = true;
  systemd.services.display-manager.serviceConfig.KeyringMode = "inherit";
  security.pam.services.sddm-autologin.text = pkgs.lib.mkBefore ''
    auth optional ${pkgs.systemd}/lib/security/pam_systemd_loadkey.so
    auth include sddm
  '';
}
