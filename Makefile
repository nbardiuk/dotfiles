.PHONY: update
update:
	nix flake update

.PHONY: switch
switch:
	sudo nixos-rebuild switch --flake .#tuxer
	pkill --signal SIGUSR1 sxhkd

.PHONY: tvbox
tvbox:
	sudo nixos-rebuild switch --flake .#tvbox
	pkill --signal SIGUSR1 sxhkd

.PHONY: darwin
darwin:
	sudo nix run nix-darwin -- switch --flake .#darwin

.PHONY: gc
gc:
	sudo nix-collect-garbage --delete-old
	nix-collect-garbage --delete-old
