{ config, pkgs, ... }:

{
  hardware.opentabletdriver.enable = false;

  environment.systemPackages = with pkgs; [
    #blender
    #krita
    #digikam
    #aseprite
  ];
}
