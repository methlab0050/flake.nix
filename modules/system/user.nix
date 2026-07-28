{pkgs, ...}: {
  users.users."mehtabs" = {
    isNormalUser = true;
    description = "Mehtab Singh";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
    ];
  };
}
