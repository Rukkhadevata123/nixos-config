{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    # 构建工具
    cmake
    gnumake
    ninja
    pkg-config

    # 添加 ASSIMP 库
    assimp # Open Asset Import Library

    # GLFW及其依赖
    glfw3 # GLFW 库本身
    xorg.libX11 # X11 库
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    xorg.libXext
    libGL # OpenGL 库
    vulkan-loader # Vulkan 支持（如果需要）

    # 常见图形库和依赖
    libGLU
    freeglut
    mesa

    # 对于 Wayland（如果需要）
    wayland
    wayland-protocols
    libxkbcommon

    # 添加 FreeType 库 (错误修复)
    freetype
    fontconfig

    # 图像处理库
    libpng
    libjpeg

    # 其他可能需要的依赖
    xorg.libXxf86vm
    libffi
    glm # OpenGL Mathematics
  ];

  # 设置环境变量
  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      # 添加 ASSIMP 到库路径
      pkgs.assimp

      # 添加 FreeType 到库路径（修复链接错误）
      pkgs.freetype
      pkgs.fontconfig

      # 图像处理库
      pkgs.libpng
      pkgs.libjpeg

      pkgs.glfw3
      pkgs.xorg.libX11
      pkgs.xorg.libXrandr
      pkgs.xorg.libXinerama
      pkgs.xorg.libXcursor
      pkgs.xorg.libXi
      pkgs.xorg.libXext
      pkgs.libGL
      pkgs.vulkan-loader
      pkgs.libGLU
      pkgs.freeglut
      pkgs.mesa
      pkgs.wayland
      pkgs.libxkbcommon
      pkgs.xorg.libXxf86vm
      pkgs.libffi
      pkgs.glm
    ]}"

    # 帮助 CMake 找到 ASSIMP
    export ASSIMP_INCLUDE_DIR="${pkgs.assimp}/include"
    export ASSIMP_LIBRARY="${pkgs.assimp}/lib/libassimp.so"

    # 帮助 CMake 找到 FreeType（修复错误）
    export FREETYPE_INCLUDE_DIRS="${pkgs.freetype.dev}/include/freetype2"
    export FREETYPE_LIBRARY="${pkgs.freetype}/lib/libfreetype.so"

    # 如果 CMake 找不到 GLFW，可以手动设置这些变量
    export GLFW3_INCLUDE_DIR="${pkgs.glfw3}/include"
    export GLFW3_LIBRARY="${pkgs.glfw3}/lib/libglfw.so"

    # 设置 OpenGL 首选项为 GLVND (解决警告)
    export OpenGL_GL_PREFERENCE="GLVND"

    # Help compiler find OpenGL headers
    export C_INCLUDE_PATH="${pkgs.mesa}/include:${pkgs.xorg.libX11.dev}/include:${pkgs.libglvnd.dev}/include:$C_INCLUDE_PATH"
    export CPLUS_INCLUDE_PATH="$C_INCLUDE_PATH"

    # 帮助 FindXXX.cmake 找到库
    export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH:${pkgs.glfw3}:${pkgs.assimp}:${pkgs.freetype}:${pkgs.fontconfig}"

    # 创建 CMake 工具链文件以设置 OpenGL 策略
    cat > opengl_toolchain.cmake << EOF
    # 设置使用 GLVND 的 OpenGL
    set(OpenGL_GL_PREFERENCE "GLVND")
    # 设置 CMake 策略 CMP0072
    if(POLICY CMP0072)
      cmake_policy(SET CMP0072 NEW)
    endif()
    EOF

    echo "OpenGL 开发环境已准备就绪"
    echo "使用以下命令运行 CMake 来解决问题:"
    echo "cmake -DCMAKE_TOOLCHAIN_FILE=\$PWD/opengl_toolchain.cmake .."
  '';
}
