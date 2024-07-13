{...}: {
  # testing importing new modules with configs
  # not importing via home-manager as these call home-manager
  # as a module and are not themselves home-manager-modules 🍝
  imports = [
    ./wifi
    ./coral
  ];
}
