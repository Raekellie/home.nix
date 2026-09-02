{pkgs, ...}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      plasma-login-manager.enable = true;
      autoLogin.user = "raquel";
    };
  };

  programs = {
    kdeconnect.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.discover # Software center (useful for flatpaks)
    kdePackages.kcalc
    kdePackages.kcharselect # Special character picker
    kdePackages.kclock
    kdePackages.kcolorchooser # Colour picker
    kdePackages.kolourpaint # Paint
    kdePackages.ksystemlog # System log viewer
    kdePackages.kate
    kdePackages.filelight # Disk space usage visualiser

    kdiff3 # Compares and merges 2 or 3 files or directories

    kdePackages.kleopatra
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
  ];

  # FIXME: remove when nixpkgs#126590 is fixed. NixOS causes excessively long envvars, and KDE slows down due to that
  # Source: GitHub: https://github.com/NixOS/nixpkgs/issues/126590#issuecomment-3694376547
  nixpkgs.overlays = [
    (final: prev: {
      kdePackages = prev.kdePackages.overrideScope (
        kdeFinal: kdePrev: {
          # https://old.reddit.com/r/NixOS/comments/1pdtc3v/kde_plasma_is_slow_compared_to_any_other_distro/
          # https://github.com/NixOS/nixpkgs/issues/126590#issuecomment-3194531220
          plasma-workspace = let
            # the package we want to override
            basePkg = kdePrev.plasma-workspace;
            # a helper package that merges all the XDG_DATA_DIRS into a single directory
            xdgdataPkg = final.stdenv.mkDerivation {
              name = "${basePkg.name}-xdgdata";
              buildInputs = [basePkg];
              dontUnpack = true;
              dontFixup = true;
              dontWrapQtApps = true;
              installPhase = ''
                mkdir -p $out/share
                ( IFS=:
                  for DIR in $XDG_DATA_DIRS; do
                    if [[ -d "$DIR" ]]; then
                      ${prev.lib.getExe prev.lndir} -silent "$DIR" $out
                    fi
                  done
                )
              '';
            };
            # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
            # script and instead inject the path of the above helper package
            derivedPkg = basePkg.overrideAttrs {
              preFixup = ''
                for index in "''${!qtWrapperArgs[@]}"; do
                  if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                    unset -v "qtWrapperArgs[$((index+0))]"
                    unset -v "qtWrapperArgs[$((index+1))]"
                    unset -v "qtWrapperArgs[$((index+2))]"
                    unset -v "qtWrapperArgs[$((index+3))]"
                  fi
                done
                qtWrapperArgs=("''${qtWrapperArgs[@]}")
                qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
              '';
            };
          in
            derivedPkg;
        }
      );
    })
  ];
}
