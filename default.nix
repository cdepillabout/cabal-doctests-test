
let
  nixpkgsSrc = builtins.fetchTarball {
    url = https://github.com/NixOS/nixpkgs/archive/c5aabb0d603e2c1ea05f5a93b3be82437f5ebf31.tar.gz;
    sha256 = "15fwszhn6078sbrb8qk83g8afvh4qnmvff0qbkbvq3cm1fxni2w1";
  };


  haskell-nix-src = ~/git/haskell.nix;

  haskell-nix = import haskell-nix-src;

  nixpkgs = import nixpkgsSrc {
    config = haskell-nix.config;
    overlays = haskell-nix.overlays;
  };

  thisProject =
    nixpkgs.haskell-nix.cabalProject {
      src = nixpkgs.haskell-nix.haskellLib.cleanGit { src = ./.; };
      index-state = "2020-01-26T00:00:00Z";
      # ghc = pkgs.buildPackages.pkgs.haskell-nix.compiler.${haskellCompiler};
      # pkg-def-extras = [
      #   # Additional packages ontop of all those listed in `cabal.project`
      # ];
      # modules = [
      #   # Specific package overrides would go here for example:
      #   packages.cbors.package.ghcOptions = "-Werror";
      #   packages.cbors.patches = [ ./one.patch ];
      #   packages.cbors.flags.optimize-gmp = false;
      #   # It may be better to set flags in `cabal.project` instead
      #   # (`plan-to-nix` will include them as defaults).
      # ];
    };
in

thisProject
