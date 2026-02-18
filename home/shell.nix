{ config, pkgs, ... }:

{
  home.sessionVariables = {
    # Using programs.vim.enable enforces a custom HM vim that doesn't play as nice with out-of-HM configs
    # (ignores configs on the home directory for one)
    EDITOR = "vim";
    VISUAL = "vim";
    SYSTEMD_EDITOR = "vim";
  };

  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "nixswitch" = "sudo nixos-rebuild switch --flake ~/nixos-config";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Raquel";
        email = "dev@raquellie.com";
      };
      init.defaultBranch = "main";
    };
  };

  home.packages = with pkgs; [ ];
}
