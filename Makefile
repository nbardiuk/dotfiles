.PHONY: update
update:
	nix flake update

.PHONY: switch
switch:
	sudo nixos-rebuild switch --show-trace --flake .#tuxer
	pkill --signal SIGUSR1 sxhkd
