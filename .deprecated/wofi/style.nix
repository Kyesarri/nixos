#  css adapted from https://github.com/jsw08/dots/blob/master/modules/jsw_home/wofi/wofi/style.css
{
  inputs,
  outputs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}
  
}
