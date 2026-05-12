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
      promptInit = "${pkgs.starship}/bin/starship init fish | source";
    };
    starship = {
      enable = true;
      settings = lib.fileContents "${inputs.dotfiles}/config/starship.toml";
    };

    bash = {
      enable = true;
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && [[ "$SHLVL" == [1,2] ]]; then
        	exec ${pkgs.fish}/bin/fish
        		fi
      '';
    };
  };
}
