{
  description = "编译GLFW";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    # system should match the system you are running on
    system = "x86_64-linux";
    # system = "x86_64-darwin";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {
        inherit system;
      };
    in
      pkgs.mkShell {
        packages = with pkgs; [
          # 构建工具
          pkg-config
          cmake
          gcc
          gnumake

          # X11 依赖
          xorg.libX11
          xorg.libXrandr
          xorg.libXinerama
          xorg.libXcursor
          xorg.libXi
          xorg.libXext
          xorg.xorgproto # 需要 X11 头文件
          libGL
          libGLU

          # Wayland 依赖
          wayland
          wayland-protocols
          wayland-scanner
          libxkbcommon

          # 添加 libffi 依赖 - 解决警告
          libffi

          # 其他可能需要的库
          vulkan-loader
          vulkan-headers

          # 额外依赖
          mesa
          libdrm

          # 文档生成 (可选)
          # doxygen
        ];

        # 环境变量设置
        shellHook = ''
          # X11 相关变量
          export X11_INCLUDE_DIR=${pkgs.xorg.libX11.dev}/include
          export X11_LIBRARY=${pkgs.xorg.libX11}/lib

          # Wayland 相关变量
          export WAYLAND_INCLUDE_DIR=${pkgs.wayland.dev}/include
          export WAYLAND_LIBRARY=${pkgs.wayland}/lib
          export WAYLAND_PROTOCOLS=${pkgs.wayland-protocols}/share/wayland-protocols

          # 确保 wayland-scanner 在 PATH 中
          export PATH=${pkgs.wayland-scanner}/bin:$PATH

          # Vulkan 相关变量
          export VULKAN_SDK=${pkgs.vulkan-loader}/lib
          export VULKAN_INCLUDE=${pkgs.vulkan-headers}/include

          # PKG_CONFIG_PATH - 添加 libffi
          export PKG_CONFIG_PATH=${pkgs.libGL}/lib/pkgconfig:${pkgs.libxkbcommon}/lib/pkgconfig:${pkgs.wayland.dev}/lib/pkgconfig:${pkgs.libffi.dev}/lib/pkgconfig:$PKG_CONFIG_PATH

          # 确保所有 libffi 相关的路径都正确设置
          export CFLAGS="-I${pkgs.libffi.dev}/include $CFLAGS"
          export LDFLAGS="-L${pkgs.libffi.out}/lib $LDFLAGS"
          export LD_LIBRARY_PATH="${pkgs.libffi.out}/lib:$LD_LIBRARY_PATH"

          # Doxygen 路径 (如果需要文档)
          # export PATH=${pkgs.doxygen}/bin:$PATH

          echo "GLFW 编译环境已准备就绪"
        '';
      };
  };
}
