{
  description = "";
  inputs = {
    # Found by considering history of pkgs.nix:
    # https://github.com/NixOS/nixpkgs/commits/master/pkgs/tools/typesetting/tex/texlive/pkgs.nix
    # nixpkgs.url = "github:NixOS/nixpkgs?rev=c5787e5b8cc68d9478758b742f5da43b5ee7f909";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [
          pkgs.direnv
          pkgs.just
          self.packages.${system}.xelatex
        ];
      };
    });
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      texlive = with pkgs;
        texlive.combine {
          inherit
            (texlive)
            scheme-small
            academicons
            arydshln
            fontawesome5
            marvosym
            moderncv
            multirow
            ;
        };
      xelatex = with pkgs;
        runCommand "xelatex" {
          nativeBuildInputs = [makeWrapper];
        }
        ''
          mkdir -p $out/bin
          makeWrapper ${self.packages.${system}.texlive}/bin/xelatex $out/bin/xelatex \
            --prefix FONTCONFIG_FILE : ${makeFontsConf {fontDirectories = [lmodern font-awesome_4];}}
        '';
    });
  };
}
