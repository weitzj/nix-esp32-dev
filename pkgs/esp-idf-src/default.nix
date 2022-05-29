# When updating to a newer version, check if the version of `esp32-toolchain-bin.nix` also needs to be updated.
{ rev ? "v4.4.1"
, sha256 ? "sha256-4dAGcJN5JVV9ywCOuhMbdTvlJSCrJdlMV6wW06xcrys="
, stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "esp-idf-src";
  version = rev;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf";
    rev = rev;
    sha256 = sha256;
    fetchSubmodules = true;
  };

  # This is so that downstream derivations will have IDF_PATH set.
  setupHook = ./setup-hook.sh;

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
