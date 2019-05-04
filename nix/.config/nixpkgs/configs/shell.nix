{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./zsh.nix
  ];
}
