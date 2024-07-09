.PHONY: update
update:
	nix flake update

.PHONY: switch
switch:
	sudo nixos-rebuild switch --flake .#tuxer
	pkill --signal SIGUSR1 sxhkd

.PHONY: darwin
darwin:
	nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#darwin

.PHONY: gc
gc:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d
