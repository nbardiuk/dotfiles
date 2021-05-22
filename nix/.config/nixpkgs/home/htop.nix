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
      show_program_path = false;
    } // (leftMeters {
      CPU = modes.Graph;
      Memory = modes.Graph;
    }) // (rightMeters {
      Tasks = modes.Text;
      AllCPUs2 = modes.Bar;
      Memory = modes.Bar;
      Swap = modes.Bar;
    });
  };
}
