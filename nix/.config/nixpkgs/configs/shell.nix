{ pkgs, ... }:
{
  imports = [
    ./fzf.nix
    ./direnv.nix
    ./zsh.nix
  ];
}
