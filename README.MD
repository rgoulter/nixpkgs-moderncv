# Nixpkgs ModernCV

Repository which builds [moderncv](https://ctan.org/pkg/moderncv?lang=en)
documents using [nixpkgs](https://nixos.org/).

This repository can be used as a template to create a (private) repository
which can automatically generate PDFs from the LaTeX document in tagged
releases.

[Example of PDF generated from template.tex](https://github.com/rgoulter/nixpkgs-moderncv/releases/download/v1.0/template.pdf).

![](moderncv_example.png)

## Setup

Follow the instructions for [installing Nix](https://nixos.org/download.html):

```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

## Building PDF

### Running with Nix

With Nix installed, building e.g. `resume.tex` in the current directory can
be done with:

```
nix run .#xelatex resume.tex
```

with the resulting PDF ending up in `./resume.pdf`.

### Using Direnv

Alternatively, you can enter a shell that can build the LaTeX documents by using
[direnv](https://direnv.net/).

Allowing the `.envrc` file with

```
direnv allow
```

will load the packages from the `default` `devShell` in the `flake.nix`,
which allows building `resume.tex` using:

```
just resume.tex
```

or

```
xelatex resume.tex
```

to generate `resume.pdf` in the current directory.

## GitHub Action

The GitHub Action workflow defined in `.github/workflows` will build and
upload the generated PDF for tags which start with `v`. e.g. `v1.0`.
