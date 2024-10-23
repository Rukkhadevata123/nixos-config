with import <nixpkgs> {}; let
  gccForLibs = stdenv.cc.cc;
in
  stdenv.mkDerivation {
    name = "llvm-env";
    buildInputs = [
      clang
    ];

    CPLUS_INCLUDE_PATH = "${gccForLibs}/include/c++/${gccForLibs.version}:${gccForLibs}/include/c++/${gccForLibs.version}/x86_64-unknown-linux-gnu:${gccForLibs}/lib/gcc/x86_64-unknown-linux-gnu/${gccForLibs.version}/include:${stdenv.cc.libc.dev}/include";

    shellHook = ''

    '';
  }
