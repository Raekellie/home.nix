{ config, pkgs, ... }:

{
  #hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
    #blender-hip
    #krita
    #digikam
    #aseprite
  ];
}
