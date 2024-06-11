.PHONY: update
update:
	nix flake update

.PHONY: switch
switch:
	sudo nixos-rebuild switch --flake .#tuxer
	pkill --signal SIGUSR1 sxhkd
