{
  description = "ESP32 development tools";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05"; 
    flake-utils.url = "github:numtide/flake-utils";
    esp-gcc = { 
      url = "github:weitzj/nix-esp-gcc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, esp-gcc, rust-overlay, ... }: {
    overlay = final: prev: {
      gcc-xtensa-esp32-elf-bin = esp-gcc.defaultPackage.${prev.system};
      openocd-esp32-bin = prev.callPackage ./pkgs/openocd-esp32-bin.nix { };
      esp-idf-src = prev.callPackage ./pkgs/esp-idf-src { };
    };
  } // flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { 
        inherit system; 
        overlays = [ 
          self.overlay
          (import rust-overlay)
        ]; 
      };
    in
    {
      packages = {
        inherit (pkgs)
          gcc-xtensa-esp32-elf-bin
          openocd-esp32-bin
          esp-idf-src;
      };

      devShell = import ./shells/esp32-idf.nix { inherit pkgs; };
    });
}
