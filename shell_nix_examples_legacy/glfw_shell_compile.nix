{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    pkg-config
    cmake
    # X11 dependencies
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    xorg.libXext
    xorg.xorgproto # Needed for X11 headers
    libGL
    libGLU
    vulkan-loader
    # Wayland dependencies
    wayland
    wayland-protocols
    libxkbcommon
  ];

  # Explicitly set environment variables for X11
  shellHook = ''
    export X11_INCLUDE_DIR=${pkgs.xorg.libX11.dev}/include
    export X11_LIBRARY=${pkgs.xorg.libX11}/lib
  '';
}
