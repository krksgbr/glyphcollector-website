let
  pkgs = import (fetchGit {
    name = "nixpkgs-20.03-beta";
    url = "git@github.com:nixos/nixpkgs.git";
    rev = "793fc88dbe9c8f53b144fd970a3685f7b1dec729";
    ref = "refs/tags/20.03-beta";
  }) {};

in
with pkgs;
mkShell {
  shellHook = ''
  export PATH=`pwd`/node_modules/.bin:$PATH
  '';
  buildInputs = [
    elmPackages.elm
    elmPackages.elm-format
    nodePackages.node2nix
    yarn
  ];
}
