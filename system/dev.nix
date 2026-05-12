{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra # TODO: wrapper so as to always be called with the arg to use tabs. Ref.: pkgs.symlinkJoin, pkgs.mkWrapper
    nil
    #rustup

    #git-filter-repo

    #godotPackages.godot
    #godotPackages.godot-export-templates-bin
    #steam-run # Useful to be able to run Godot games without messing with paths
  ];
}
