{ ... }:
let
  meter = mode: kind: { inherit mode; inherit kind; };
  bar = meter 1;
  text = meter 2;
  graph = meter 3;
  led = meter 4;
in
{
  programs.htop = {
    colorScheme = 0; # Default
    enable = true;
    fields = ["PID" "USER" "STATE" "M_RESIDENT" "PERCENT_MEM" "PERCENT_CPU" "TIME" "IO_RATE" "COMM"];
    hideKernelThreads = true;
    hideThreads = true;
    hideUserlandThreads = true;
    meters.left = [(graph "CPU") (graph "Memory")];
    meters.right = [(text "Tasks") (bar "AllCPUs2") (bar "Memory") (bar "Swap")];
    showProgramPath = false;
  };
}
