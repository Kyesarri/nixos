# TODO un-used, legacy for polybar
# example = "#${colour.red1}";
# # is required, workaround to add transparency if required later
# to enable transparency:
# example = "#99${colour.black}";
# uses hex values 00 to ff for transparency case is irrelevant
# been calling these from a home-manager module ex :
#
#     programs.kitty =
#     { ...
#      active_tab_foreground = "#${colour.accent1}";
{
  red = "FF0000";
  green = "008000";
  blue = "0000ff";
  yellow = "ffff00";
  white = "FFFFFF";
  black = "000000";
  background = "1F2127";
  alternate = "26292E";
  text = "FFFFFF";
  accent1 = "ff6376"; # wild watermelon
  accent2 = "3c78ff"; # azure radiance
  accent3 = "19c0ca"; # java
}
