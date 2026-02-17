{ config, pkgs, ... }:

{
  hardware.opentabletdriver.enable = false;

  environment.systemPackages = with pkgs; [
    #blender-hip
    #krita
    #digikam
    #aseprite
  ];
}
