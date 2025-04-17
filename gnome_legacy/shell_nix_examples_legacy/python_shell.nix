{
  pkgs ?
    import <nixpkgs> {
      config = {allowUnfree = true;};
    },
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
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
  shellHook = ''
  '';
}
