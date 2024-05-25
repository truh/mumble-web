{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages = {
          default = self.packages.${system}.mumble-web;
          mumble-web = pkgs.buildNpmPackage rec {
            pname = "mumble-web";
            version = "0.5.1";

            src = pkgs.fetchFromGitHub {
              owner = "truh";
              repo = pname;
              rev = "4ef594c8a097d180700d22d91e9a7fea3bab08ac";
              hash = "sha256-fcNPQHQDQM2SHU+YKo1VFXNUtN/dyQzs0bw9z1nQ2MQ=";
            };
            forceGitDeps = true;
            npmDepsHash = "sha256-UD4C7Oaelwn/4zkhJhA2tPm/j7D8eCDK9QNMjGsAL5A=";

            npmFlags = ["--legacy-peer-deps"];

            meta = with nixpkgs.lib; {
              description = "An HTML5 Mumble client";
              homepage = "https://github.com/Johni0702/mumble-web";
              license = licenses.isc;
              maintainers = with maintainers; [truh];
            };
          };
        };
        formatter = pkgs.alejandra;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_latest
          ];
        };
      }
    );
}
