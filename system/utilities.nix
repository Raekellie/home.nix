{
  inputs,
  config,
  pkgs,
  ...
}:

{
  # TODO: these declarations are useful but don't belong in this file
  #environment.sessionVariables = rec {
  #  XDG_CONFIG_HOME = "$HOME/.config";
  #  XDG_DATA_HOME = "$HOME/.local/share";
  #  XDG_STATE_HOME = "$HOME/.local/state";
  #  XDG_CACHE_HOME = "$HOME/.cache";
  #};

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
    jq

    starship
    ripgrep
    fd
    bat
    eza
    fzf

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
