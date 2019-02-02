# nixfiles

This repository declaratively defines the software I use on my computers and notebook thanks to [Nix](https://nixos.org/nix/) and [NixOS](https://nixos.org/). With these nix definitions and my [dotfiles](https://github.com/fuerbringer/unixfiles) one could perfectly replicate my exact desktop setups.

## Structure

- `modules`: nix modules
- `common`: static nix files (should probably convert those into modules)
- `pkgs`: nix derivations for small shell scripts

### Machines

- `carbon-brick`: Thinkpad
- `cyberdeck`: Another Thinkpad
- `orbit`: Home PC (not used)

## Usage

NixOS machine profiles are inside subfolders. They can be deployed using the supplied `deploy.sh` bash script.

Example: `./deploy.sh deploy carbon-brick`
