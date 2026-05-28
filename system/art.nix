{
  config,
  pkgs,
  ...
}: {
  hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
    krita
    digikam
    #blender
    #aseprite

    kdePackages.kdenlive
  ];
}
