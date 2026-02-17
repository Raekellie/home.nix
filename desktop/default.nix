{ config, pkgs, ... }:

{
  imports = [
    ./kde.nix
    ./desktop.nix
    ./art.nix
    ./dev.nix
    ./gaming.nix
  ];
}
