{
  lib,
  pkgs,
  ...
}:

{
  programs.fish.enable = true;

  # It's not a good idea to set fish as the login shell directly
  users.defaultUserShell = pkgs.bash;
  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      		if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && [[ "$SHLVL" == [1,2] ]]; then
      			exec ${pkgs.fish}/bin/fish
      		fi
      	'';
  };

}
