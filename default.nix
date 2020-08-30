{ pkgs ? import <nixpkgs> {} }: with pkgs; let
  uttools = stdenv.mkDerivation {
    name = "pearl000-tools";

    src = builtins.filterSource (path: type: builtins.match ".*\\.sh" path != null) ./.;

    phases = [ "installPhase" "fixupPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/asmupload.sh $out/bin/ut-asmupload
      cp $src/upload.sh    $out/bin/ut-upload
      cp $src/detect.sh    $out/bin/ut-detect
    '';
  };

  hex2hex = stdenv.mkDerivation {
    name = "hex2hex";
    src = ./hex2hex;

    phases = [ "buildPhase" ];

    buildPhase = ''
      mkdir -p $out/bin
      $CC -o $out/bin/hex2hex $src/hex2hex.c
    '';
  };

  shell = mkShell {
    name = "pearl000-files";

    buildInputs = [
      hex2hex
      uttools
      avrdude
      avra
      putty
    ];
  };
in shell
