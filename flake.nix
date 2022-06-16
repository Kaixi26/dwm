{
  description = "dwm - dynamic window manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixpkgs, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs { inherit system; };

    lib = nixpkgs.lib;

    buildInputs = with pkgs; [
      xorg.libX11 xorg.libXinerama xorg.libXft
      gnumake
      gcc
    ];

  in {

    defaultPackage.x86_64-linux = pkgs.stdenv.mkDerivation {
      name = "dwm-6.3";
      src = ./.;
      buildInputs = buildInputs;
      installPhase = ''
        mkdir -p "$out"
        make install DESTDIR=$out
      '';
    };

    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = buildInputs ++ [
        pkgs.xorg.xorgserver
      ];
    };
  };
}
