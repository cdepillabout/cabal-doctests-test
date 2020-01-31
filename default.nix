
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
      modules = [
        {
          # packages.ghc.flags.ghci = true;
          # packages.ghci.flags.ghci = true;

          # reinstallableLibGhc = true;

          # This is needed for the doctest library to be built.
          nonReinstallablePkgs =
            [ "rts" "ghc-heap" "ghc-prim" "integer-gmp" "integer-simple" "base"
              "deepseq" "array" "ghc-boot-th" "pretty" "template-haskell"
              "ghc-boot"
              "ghc" "Cabal" "Win32" "array" "binary" "bytestring" "containers"
              "directory" "filepath" "ghc-boot" "ghc-compact" "ghc-prim"
              "ghci" "haskeline"
              "hpc"
              "mtl" "parsec" "process" "text" "time" "transformers"
              "unix" "xhtml"
              "stm" "terminfo"
            ];

          packages.cabal-doctests-test.components.tests.doctests.isDoctest = true;
          packages.cabal-doctests-test.components.tests.doctests.preBuild = ''
            echo __________________________________________________________________________________________________________________________________________________
            set -x
            pwd
            ls -lah
            set +x
          '';
        }
      ];
    };
in

thisProject
