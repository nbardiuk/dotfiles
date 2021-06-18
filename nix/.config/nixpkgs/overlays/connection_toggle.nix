final: previous:
with final;
{
  connection_toggle = writeBb "connection-toggle" {
    content = ./connection-toggle.clj;
    deps = [ rofi networkmanager ];
  };
}
