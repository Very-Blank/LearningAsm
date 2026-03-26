{
  description = "Assembly flake";

  # Info on development environments: https://nixos-and-flakes.thiscute.world/development/intro

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixnvim = {
      url = "github:Very-Blank/NixNvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {inherit system;};
      runScript = pkgs.writeShellApplication {
        name = "run";
        runtimeInputs = [pkgs.binutils];
        text = ''
          set +e

          if [[ "$#" -ne 1 ]]; then
              echo "Illegal number of parameters." >&2
              exit 2
          fi

          as "$1" -o obj.o
          ld obj.o -o bin
          rm obj.o
          ./bin
          echo "Program output: $?"
          rm bin
        '';
      };
    in
      pkgs.mkShell {
        packages = [
          runScript
          (
            inputs.nixnvim.packages.${pkgs.stdenv.system}.default.override {
              extraConfig = {...}: {
                config = {
                  vim = {
                    languages.assembly.enable = true;
                    languages.assembly.lsp.enable = true;
                    languages.assembly.treesitter.enable = true;
                  };
                };
              };
            }
          )
        ];

        shellHook = ''
          exec ${pkgs.lib.getExe pkgs.tmux}
        '';
      };
  };
}
