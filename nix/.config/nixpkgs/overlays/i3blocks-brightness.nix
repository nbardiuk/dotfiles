final: previous:
with final;
{
  i3blocks-brightness = writeBb "brightness" {
    content = ./i3blocks-brightness.clj;
    deps = [ light ];
  };
}
