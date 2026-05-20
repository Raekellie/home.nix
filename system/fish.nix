{
  inputs,
  lib,
  pkgs,
  ...
}: {
  # It's not a good idea to set fish as the login shell directly
  users.defaultUserShell = pkgs.bash;

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = lib.fileContents "${inputs.dotfiles}/config/config.fish";
      promptInit = "${pkgs.starship}/bin/starship init fish | source";
    };
    starship = {
      enable = true;
      settings = lib.fromTOML (lib.fileContents "${inputs.dotfiles}/config/starship.toml");
    };

    bash = {
      enable = true;
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && "$SHLVL" == [1,2] ]]; then
        	exec ${pkgs.fish}/bin/fish
        		fi
      '';
    };
  };
}
