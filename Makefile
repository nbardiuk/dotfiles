.PHONY: update
update:
	nix flake update

.PHONY: switch
switch:
	sudo nixos-rebuild switch --flake .#tuxer
	pkill --signal SIGUSR1 sxhkd

.PHONY: gc
gc:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d
