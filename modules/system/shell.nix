{ config, pkgs, ... }:

{
  programs.bash.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    # Editors
    vim-full

    # Utilities
    file
    which
    gawk
    gnused
    tree

    git
    curl
    wget

    starship
    ripgrep
    bat
    eza
    fzf
    jq

    # File management
    ranger

    zip
    unzip
    gnutar
    xz
    gzip

    # Networking
    bind
    ipcalc

    # System management
    lm_sensors
    pciutils
    ethtool
    usbutils

    killall
  ];
}
