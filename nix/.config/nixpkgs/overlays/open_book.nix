final: previous:
with final;
{
  open_book = writeBb "open-book" {
    content = ./open-book.clj;
    deps = [ rofi zathura ];
  };
}
