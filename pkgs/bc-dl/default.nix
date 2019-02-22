with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "bc-dl";
  version = "1.0.0";

  buildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${./bc-dl} $out/bin/${name}

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils ]}
    done
  '';
}
