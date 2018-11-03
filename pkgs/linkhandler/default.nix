with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "linkhandler";
  version = "1.0.0";

  buildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${./linkhandler} $out/bin/${name}

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils mpv wget feh w3m dmenu utillinux ]}
    done
  '';
}
