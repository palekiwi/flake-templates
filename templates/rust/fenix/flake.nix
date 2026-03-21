{
  description = "A Rust flake with fenix";

  nixConfig = {
    extra-substituters = [ "https://palekiwi-labs.cachix.org" ];
    extra-trusted-public-keys = [ "palekiwi-labs.cachix.org-1:cqmRwFBlOVtJwi13WbQ2Vszyvjom4dHOGXBgwAZXHVQ=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, fenix, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # !!! RENAME YOUR PROJECT HERE !!!
        projectName = "my-rust-project";
        pkgs = nixpkgs.legacyPackages.${system};
        rustToolchain = fenix.packages.${system}.stable.toolchain;
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = projectName;
          version = "0.1.0";
          src = pkgs.lib.cleanSource ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs = [ rustToolchain ];

          # Add any system dependencies your package needs
          buildInputs = [];

          meta = with pkgs.lib; {
            description = "A new Rust project";
            license = licenses.mit;
            maintainers = [ ];
          };
        };

        devShells.default = pkgs.mkShell
          {
            buildInputs = [
              rustToolchain
              pkgs.rust-analyzer
              pkgs.cargo-expand
              pkgs.cargo-watch
              pkgs.cargo-edit
            ];

            shellHook = ''
              echo "Rust development environment ready!"
              echo "Rust version: $(rustc --version)"
            '';
          };
      });
}
