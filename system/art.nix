{
  config,
  pkgs,
  ...
}: {
  hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
    krita
    digikam
    pkgsRocm.blender
    #aseprite

    kdePackages.kdenlive
  ];
}
