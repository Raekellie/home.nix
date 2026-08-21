{
  pkgs,
  pkgs-unstable,
  ...
}: {
  hardware.opentabletdriver = {
    enable = true;
    package = pkgs.patched-opentabletdriver;
  };
  # TODO: remove OTD patches when upstreamed - adds support for the inner trackpad wheel
  # Patches written by https://github.com/Mrcubix
  nixpkgs.overlays = [
    (final: super: {
      # Replace `pkgs-unstable` with `super` to use the version available in stable NixOS
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
    pkgs-unstable.pkgsRocm.blender # Not worth the effort to decouple when I do not have any non-AMD-GPU machine

    #digikam
    #aseprite

    kdePackages.kdenlive
  ];
}
