{
  description = "Minimal Rust development environment (LSP-focused)";

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
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Common native dependencies
        nativeDeps = with pkgs; [
          pkg-config
          openssl
          zlib
        ];

        mkRustShell = toolchain: pkgs.mkShell {
          buildInputs = nativeDeps ++ [
            toolchain
          ];

          shellHook = ''
            echo "Rust $(rustc --version) devshell loaded"
          '';
        };

        # Toolchain definitions
        stableToolchain = fenix.packages.${system}.combine [
          fenix.packages.${system}.stable.toolchain
          fenix.packages.${system}.stable.rust-analyzer
          fenix.packages.${system}.stable.rust-src
        ];

        nightlyToolchain = fenix.packages.${system}.combine [
          fenix.packages.${system}.latest.toolchain
          fenix.packages.${system}.latest.rust-analyzer
          fenix.packages.${system}.latest.rust-src
        ];

      in
      {
        devShells = {
          default = mkRustShell stableToolchain;
          stable = mkRustShell stableToolchain;
          nightly = mkRustShell nightlyToolchain;
        };
      });
}
