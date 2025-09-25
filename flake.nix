{
  description = "Flake for tofi - tiny dynamic menu for Wayland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation rec {
      pname = "tofi";
      version = "0.9.1";

      src = self;

      nativeBuildInputs = with pkgs; [
        meson
        ninja
        pkg-config
        scdoc
        wayland-protocols
        wayland-scanner
      ];

      buildInputs = with pkgs; [
        freetype
        harfbuzz
        cairo
        pango
        wayland
        libxkbcommon
      ];

      meta = with pkgs.lib; {
        description = "Tiny dynamic menu for Wayland";
        homepage = "https://github.com/philj56/tofi";
        license = licenses.mit;
        maintainers = with maintainers; [fbergroth];
        platforms = platforms.linux;
        mainProgram = "tofi";
      };
    };

    defaultPackage.${system} = self.packages.${system}.default;
    apps.${system}.default = {
      type = "app";
      program = "${self.packages.${system}.default}/bin/tofi";
    };
  };
}
