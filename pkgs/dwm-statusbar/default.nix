with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "dwm-statusbar";
  version = "1.0.0";

  buildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${./dwm-statusbar} $out/bin/${name}

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils acpi lm_sensors ]}
    done
  '';
}
