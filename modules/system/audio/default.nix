{ ... }: {
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig = {
      "10-default-input-volume" = {
        "wireplumber.rules" = [
          {
            matches = [
              {
                "media.class" = "Audio/Source";
                "device.api" = "alsa";
              }
            ];
            actions = {
              update-props = {
                "audio.volume" = 0.25;
              };
            };
          }
        ];
      };
    };
  };
}
