final: previous:
let
  connection_toggle = (final.writers.writePython2Bin "connection_toggle.py" { libraries = [ final.python2Packages.sh ]; } ''
    import sh

    # get table of connections from nmcli
    connections = str(sh.nmcli(
           "--colors", "no",
           "--fields", "name,type,state",
           "connection", "show"))

    # split the table into header and rows
    header, rows = connections.split("\n", 1)

    # use rofi promt to chose connection
    selection = sh.rofi(sh.echo(rows), "-dmenu",
                        "-i",
                        "-p", "Toggle Connection",
                        "-mesg", header)

    name = selection.split()[0]
    state = selection.split()[-1]

    # toggle connection
    command = "up" if state == "--" else "down"
    sh.nmcli("connection", command, name)
  '').overrideAttrs( old: rec {
      buildInputs = [ final.rofi final.networkmanager ];
  });
in {
  inherit connection_toggle;
}

