{ config, pkgs, ... }:

let
  bc-dl = pkgs.writeScriptBin "bc-dl" ''
    #!${pkgs.stdenv.shell}
    # This is a script that spawns a nix shell, installs python stuff with
    # bandcamp-dl and downloads an album into a directory

    nix-shell -p python36Packages.virtualenv bash --run bash << EOF

    WDIR="/tmp" # Working directory
    VEDIR="pip" # Virtualenv directory

    if [ -z "$1" ] || [ -z "$2" ]; then
      echo "Please provide all arguments: 
        bc-dl [https://artist.bandcamp.com/album] [/path/to/dest/folder]"
      exit 1
    fi

    virtualenv /tmp/pip

    source /tmp/pip/bin/activate

    pip install bandcamp-downloader

    # $1: bandcamp link
    # $2: destination
    bandcamp-dl --base-dir $2 $1

    echo "Done."

    EOF
  '';
in
{
  config = {
    environment.systemPackages = with pkgs; [ bc-dl ];
  };
}
