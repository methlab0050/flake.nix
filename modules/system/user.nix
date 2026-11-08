{...}: {
  users.users."mehtabs" = {
    isNormalUser = true;
    description = "Mehtab Singh";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
    ];
    initialPassword = "abcd";
  };

  users.users."test" = {
    isNormalUser = true;
    description = "Test User";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
    ];
    initialPassword = "abcd";
  };
}
