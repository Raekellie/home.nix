{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.xppen.enable = false;
  nixpkgs.config.allowUnfreePackages = [
    "xppen_4"
  ];
  hardware.opentabletdriver = {
    enable = true;
    package = pkgs.patched-opentabletdriver;
  };
  # TODO: remove OTD patches when upstreamed - adds support for the inner trackpad wheel
  # Patches written by https://github.com/Mrcubix
  nixpkgs.overlays = [
    (final: prev: {
      # Replace `pkgs-unstable` with `prev` to use the version available in stable NixOS
      patched-opentabletdriver = pkgs-unstable.opentabletdriver.overrideAttrs (previousAttrs: {
        doCheck = false;
        patches =
          (previousAttrs.patches or [])
          ++ [
            ../custom/patches/otd-0001-trackpad-wheel.patch
          ];
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    krita
    pkgs-unstable.pkgsRocm.blender # FIXME: don't assume AMD GPU
    #digikam
    #aseprite

    kdePackages.kdenlive
  ];
}
