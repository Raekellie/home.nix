{
  config,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;
    users."raquel" = {
      isNormalUser = true;
      description = "Raquel";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzHOnKrV5nCvwKlGZxyKHkyiFcLzWmsZIVWX5iiw/V3 openpgp:0x413758D0"
      ];
      hashedPasswordFile = config.sops.secrets.initialHashedPassword.path;
      packages = with pkgs; [];
    };
  };
}
