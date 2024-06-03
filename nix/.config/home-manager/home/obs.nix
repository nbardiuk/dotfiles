{ pkgs, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins;[
      obs-3d-effect
      obs-backgroundremoval
      obs-gstreamer
      obs-pipewire-audio-capture
      obs-webkitgtk
      waveform
    ];
  };
}
