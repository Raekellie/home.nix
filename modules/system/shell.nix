{ config, pkgs, ... }:

{
  programs.bash.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.sessionVariables = rec {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    # FIXME: Incorporate my dotfiles repo within this one so as to make this 100% reproducible
    DOTFILES        = " $XDG_CONFIG_HOME/dotfiles";

    PATH = [
      "${DOTFILES}/environment/path"
    ];
  };

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
