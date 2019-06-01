final: previous:
let
  open_book = (final.writers.writeBashBin "open_book.sh" ''
      find \
        -H \
        ~/Books \
        ~/Pragmatic\ Bookshelf \
        -type f \
    | grep \
        --invert-match \
        --regexp='/\.' \
    | sed \
        --expression='s/^\(.*\)\/\([^/]*\)$/\2 〈 \1/' \
    | rofi \
        -dmenu \
        -i \
        -p "Open a book" \
    | sed \
        --expression='s/\(^.*\) 〈 \(.*\)$/\2\/\1/' \
    | xargs \
        --delimiter='\n' \
        --no-run-if-empty \
        zathura
  '').overrideAttrs( old: rec {
      buildInputs = [ final.rofi final.zathura ];
  });
in {
  inherit open_book;
}
