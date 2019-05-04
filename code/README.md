# MacOs

```sh
stow -t ~/Library/Application\ Support code
```

# Linux

```sh
stow -t ~/.config code
```

# Extentions

Backup the list

```sh
code --list-extensions > extentions.list
```

Restore the list
```sh
cat extentions.list | xargs -L 1 code --install-extension
```
