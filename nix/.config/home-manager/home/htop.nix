{ config, ... }:
{
  programs.htop = {
    enable = true;
    settings = with config.lib.htop; {
      color_scheme = 0; # Default
      fields = with fields; [
        PID
        USER
        STATE
        M_RESIDENT
        PERCENT_MEM
        PERCENT_CPU
        TIME
        IO_RATE
        COMM
      ];
      hide_kernel_threads = true;
      hide_threads = true;
      hide_userland_threads = true;
      highlight_base_name = true;
      show_program_path = false;
    } // (leftMeters [
      (bar "AllCPUs2")
    ]) // (rightMeters [
      (bar "Memory")
      (bar "Swap")
      (bar "DiskIO")
      (bar "NetworkIO")
    ]);
  };
}
