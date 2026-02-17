{ inputs, config, pkgs, ... }:

{
  programs.bash.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.sessionVariables = rec {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    XDG_CACHE_HOME  = "$HOME/.cache";

    DOTFILES        = "${inputs.dotfiles}";
    ZDOTDIR         = "${inputs.dotfiles}/config/zsh";
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
