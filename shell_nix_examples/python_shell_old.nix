let
  # We pin to a specific nixpkgs commit for reproducibility.
  # Last updated: 2024-04-29. Check for new commits at https://status.nixos.org.
  pkgs = import (fetchTarball "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/f6db44a8daa59c40ae41ba6e5823ec77fe0d2124.tar.gz") {};
in
  pkgs.mkShell {
    packages = [
      (pkgs.python3.withPackages (python-pkgs:
        with python-pkgs; [
          # select Python packages here
          pandas
          requests
          matplotlib
          notebook
          jupyterlab
          numpy
          pip
          scipy
          pillow
        ]))

      # Add nix-ld dependencies
      pkgs.zlib
      pkgs.zstd
      pkgs.curl
      pkgs.openssl
      pkgs.attr
      pkgs.libssh
      pkgs.bzip2
      pkgs.libxml2
      pkgs.acl
      pkgs.libsodium
      pkgs.util-linux
      pkgs.xz
      pkgs.systemd
      pkgs.xorg.libX11
      pkgs.pdftk
    ];

    #   (pkgs.writeShellScriptBin "python" ''
    #   export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
    #   exec ${pkgs.python3}/bin/python "$@"
    #   '')

    # export CUDA_PATH=${pkgs.cudatoolkit}
    # Add proxy environment variables
    shellHook = ''
      export http_proxy="http://127.0.0.1:7897"
      export https_proxy="http://127.0.0.1:7897"
      export all_proxy="socks5://127.0.0.1:7897"
      export no_proxy="127.0.0.1,localhost,internal.domain"
      # export LD_LIBRARY_PATH=$(nix eval --raw nixpkgs#gcc.cc.lib)/lib:$LD_LIBRARY_PATH

      # Setup nix-ld environment
      # export NIX_LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
        pkgs.zlib
        pkgs.zstd
        pkgs.stdenv.cc.cc
        pkgs.curl
        pkgs.openssl
        pkgs.attr
        pkgs.libssh
        pkgs.bzip2
        pkgs.libxml2
        pkgs.acl
        pkgs.libsodium
        pkgs.util-linux
        pkgs.xz
        pkgs.systemd
        pkgs.xorg.libX11
      ]}
      # export NIX_LD=${pkgs.glibc}/lib/ld-linux-x86-64.so.2


      # Python wrapper for nix-ld
      python() {
        # export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
        /usr/bin/env python "$@"
      }

      # Comment about venv setup
      # env NIXPKGS_ALLOW_UNFREE=1 nix-shell python_shell.nix
      # cd ~/.local/
      # python -m venv taichi_venv
      # source ~/.local/taichi_venv/bin/activate
      # or just
      # nix-shell -p python3 --command "python -m venv .venv --copies"
      # when you have entered your venv, use "echo $NIX_LD_LIBRARY_PATH" and apply it to your venv by "export LD_LIBRARY_PATH='the output'"
      # find /nix/store -name "*libcuda.so*" also should be added
    '';
  }
