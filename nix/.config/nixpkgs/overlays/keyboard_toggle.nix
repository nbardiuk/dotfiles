final: previous:
with final;
{
  keyboard_toggle = writeBb "keyboard-toggle" {
    content = ./keyboard-toggle.clj;
    deps = [ rofi ];
  };
}
