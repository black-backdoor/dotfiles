# dotfiles



## Configuration
When installing the dotfiles, the following functionality is added:
- Clipboard actions | pbcopy, pbpaste
- Directory navigation | .., ..., ...., home, root
- public-ip & local-ip | Get your public and local IP
- week | current week number



## Installation
```bash
sudo apt install git
```

```bash
git clone https://github.com/black-backdoor/dotfiles.git
```

```bash
sudo chmod +x ~/dotfiles/scripts/install.sh
```

```bash
sudo ~/dotfiles/scripts/install.sh
```



## Stow
This command will create symlinks for the files in the current directory to the parent directory.
```bash
stow .
```
