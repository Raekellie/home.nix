{
  pkgs,
  modulesPath,
  ...
}: {
  # https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../../services/ssh.nix
    ../../system/utilities.nix
  ];

  networking.hostName = "nixos-live-image";

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
  users.users."nixos".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzHOnKrV5nCvwKlGZxyKHkyiFcLzWmsZIVWX5iiw/V3 openpgp:0x413758D0"
  ];

  programs.vim.package = pkgs.vim;

  isoImage.squashfsCompression = "zstd";
  environment.systemPackages = with pkgs; [];
}
