{ nixpkgs ? import (builtins.fetchGit {
    name = "nixpkgs-with-texlive-with-moderncv";
    url = "https://github.com/NixOS/nixpkgs/";
    # Found by considering history of pkgs.nix:
    # https://github.com/NixOS/nixpkgs/commits/master/pkgs/tools/typesetting/tex/texlive/pkgs.nix
    rev = "c5787e5b8cc68d9478758b742f5da43b5ee7f909";
  }) {}
  # Can change "template" (for "template.tex")
  # to "filename" (for "filename.tex");
  # then can run `nix-build` to generate the PDF
  # to "./result/filename.pdf".
, document ? "cv"
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
