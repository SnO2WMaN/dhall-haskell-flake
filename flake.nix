{
  # main
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  # dhall-haskell
  inputs = {
    dhall-haskell = {
      url = "https://github.com/dhall-lang/dhall-haskell";
      type = "git";
      flake = false;
      submodules = true;
    };
    dhall-haskell-nixpkgs.url = "github:nixos/nixpkgs/391f93a83c3a486475d60eb4a569bb6afbf306ad";
  };

  # dev
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        dhall-haskell = import "${inputs.dhall-haskell}/nix/shared.nix" {
          inherit system;
          nixpkgs = inputs.dhall-haskell-nixpkgs;
        };
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages.dhall-lsp-server = dhall-haskell.dhall-lsp-server;
      }
    );
}
