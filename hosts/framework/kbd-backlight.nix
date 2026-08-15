{pkgs, ...}: let
  stateFile = "/var/lib/kbd-backlight/state";

  saveKbdState = pkgs.writeShellApplication {
    name = "save-kbd-backlight-state";
    runtimeInputs = [pkgs.brightnessctl];
    text = ''
      mkdir -p /var/lib/kbd-backlight
      level=$(brightnessctl --device='*kbd_backlight*' get 2>/dev/null || true)
      if [ -n "$level" ]; then
        echo "$level" > ${stateFile}
      fi
    '';
  };

  restoreKbdState = pkgs.writeShellApplication {
    name = "restore-kbd-backlight-state";
    runtimeInputs = [pkgs.brightnessctl];
    text = ''
      if [ -f ${stateFile} ]; then
        level=$(cat ${stateFile})
        if [ -n "$level" ]; then
          brightnessctl --device='*kbd_backlight*' set "$level" || true
        fi
      fi
    '';
  };
in {
  # Save keyboard backlight state before sleep and shutdown
  systemd.services.save-kbd-backlight = {
    description = "Save keyboard backlight state before sleep/shutdown";
    wantedBy = ["sleep.target" "shutdown.target"];
    before = ["sleep.target" "shutdown.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${saveKbdState}/bin/save-kbd-backlight-state";
    };
  };

  # Restore keyboard backlight state on boot and wake from sleep
  systemd.services.restore-kbd-backlight = {
    description = "Restore keyboard backlight state on boot and wake";
    wantedBy = ["multi-user.target" "post-resume.target"];
    after = ["post-resume.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${restoreKbdState}/bin/restore-kbd-backlight-state";
    };
  };
}
