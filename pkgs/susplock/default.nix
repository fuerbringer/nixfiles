with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "susplock";
  version = "1.0.0";

  buildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${./susplock} $out/bin/${name}

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH
    done
  '';
}
