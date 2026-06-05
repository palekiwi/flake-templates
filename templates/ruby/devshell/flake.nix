{
  description = "Ruby development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-ruby = {
      url = "github:bobvanderlinden/nixpkgs-ruby";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, flake-utils, nixpkgs-ruby, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nixpkgs-ruby.overlays.default ];
        };

        rubyVersion = pkgs.lib.fileContents ./.ruby-version;
        ruby = pkgs."ruby-${rubyVersion}";

        update-gems = pkgs.writeShellScriptBin "update-gems" ''
          set -euo pipefail
          ${pkgs.bundler}/bin/bundle lock --add-platform ruby
          ${pkgs.bundix}/bin/bundix
        '';

        gems = pkgs.bundlerEnv {
          name = "ruby-env";
          inherit ruby;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
        };
      in
      {
        packages.update-gems = update-gems;

        devShells.default = pkgs.mkShell {
          name = "ruby";
          buildInputs = [
            pkgs.bundix
            update-gems
            gems
            gems.wrappedRuby
          ];

          shellHook = ''
            echo "Ruby version: $(ruby -v)"
          '';
        };
      });
}
