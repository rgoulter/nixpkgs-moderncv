{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  customTexlive =
    texlive.combine {
      inherit (texlive)
        scheme-small
        fontawesome
        marvosym
        moderncv
      ;
    };
in
pkgs.mkShell {
  buildInputs = [
    customTexlive
  ];
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ lmodern font-awesome ]; };
}
