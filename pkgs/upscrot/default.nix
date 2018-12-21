with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "upscrot";
  version = "1.0.0";

  buildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${./upscrot} $out/bin/${name}

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils maim utillinux xclip ]}
    done
  '';
}
