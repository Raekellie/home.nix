{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #blender-hip
    krita
    #digikam
    #aseprite
  ];
}
