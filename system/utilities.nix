{
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.vim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.vim-full;
  };

  environment.systemPackages = with pkgs; [
    # Utilities
    file
    which
    gawk
    gnused
    tree

    git
    curl
    wget
    jq

    starship
    ripgrep
    fd
    bat
    eza
    fzf

    sops

    # File management
    ranger

    zip
    libarchive # bsdtar
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
