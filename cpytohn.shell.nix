{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # 编译 Python 所需的基本工具
    gcc
    makeWrapper
    pkg-config

    # 缺失模块的依赖库
    bzip2.dev
    ncurses.dev
    gdbm.dev
    openssl.dev  # 默认版本，通常是 3.x
    xz.dev
    sqlite.dev
    tk.dev
    tcl
    libuuid.dev
    readline.dev
    zlib.dev
    libffi.dev
    libxcrypt

    # 如果需要特定版本的 OpenSSL（例如 1.1.x）
    # 取消注释以下行，并注释掉上面的 openssl.dev
    # (openssl_1_1.override { static = false; }).dev
  ];

  # 设置环境变量，确保编译时能找到头文件和库
  shellHook = ''
    export CFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.xz.dev}/include"
    export LDFLAGS="-L${pkgs.zlib.out}/lib -L${pkgs.bzip2.out}/lib -L${pkgs.xz.out}/lib"
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.zlib
      pkgs.bzip2
      pkgs.xz
      pkgs.ncurses
      pkgs.gdbm
      pkgs.openssl
      pkgs.sqlite
      pkgs.tk
      pkgs.tcl
      pkgs.libuuid
      pkgs.readline
      pkgs.libffi
      pkgs.libxcrypt
    ]}"
  '';
}
