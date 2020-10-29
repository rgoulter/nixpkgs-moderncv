{ nixpkgs ? import <nixpkgs> {}
  # Can change "template" (for "template.tex")
  # to "filename" (for "filename.tex");
  # then can run `nix-build` to generate the PDF
  # to "./result/filename.pdf".
, document ? "template"
}:
with nixpkgs.pkgs;
stdenv.mkDerivation {
  name = "nixpkgs-moderncv";
  src = ./.;
  buildInputs = [
    (texlive.combine {
      inherit (texlive)
        scheme-small
        fontawesome
        marvosym
        moderncv
      ;
    })
  ];

  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ lmodern font-awesome_4 ]; };

  buildPhase = ''
    xelatex ${document}
  '';

  installPhase = ''
    mkdir -p $out
    cp ${document}.pdf $out
  '';
}
