{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # 包含硬件扫描的结果
    ./hardware-configuration.nix
  ];

  #-------------------------------
  # 引导加载程序配置
  #-------------------------------
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  #-------------------------------
  # 网络配置
  #-------------------------------
  networking = {
    hostName = "nixos";
    extraHosts = '''';
    # proxy = {
    #   httpProxy = "http://127.0.0.1:7897";
    #   httpsProxy = "http://127.0.0.1:7897";
    #   allProxy = "socks5://127.0.0.1:7897";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };
    networkmanager.enable = true;
  };

  #-------------------------------
  # 时区和国际化设置
  #-------------------------------
  time.timeZone = "Asia/Shanghai";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-chinese-addons
        ];
        waylandFrontend = true;
      };
    };
  };

  #-------------------------------
  # 显示服务和桌面环境
  #-------------------------------
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = [
      "modesetting"
      "nvidia"
    ];
    desktopManager.runXdgAutostartIfNone = true;
  };

  # KDE Plasma 配置 (使用新路径)
  services.desktopManager = {
    plasma6.enable = false;
    gnome.enable = true;
  };

  # 显示管理器配置 (使用新路径)
  services.displayManager = {
    sddm = {
      enable = false;
      wayland.enable = true;
    };
    gdm.enable = true;
  };

  #-------------------------------
  # 系统服务配置
  #-------------------------------
  services = {
    gnome = {
      games.enable = true;
      gnome-keyring.enable = true;
    };
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };
    flatpak.enable = false;
    blueman.enable = true;
    envfs.enable = true;
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
    akkoma = {
      enable = false;
    };
  };

  #-------------------------------
  # 地理位置设置
  #-------------------------------
  location = {
    latitude = 30.26;
    longitude = 120.19;
  };

  #-------------------------------
  # 安全配置
  #-------------------------------
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  #-------------------------------
  # XDG 门户配置
  #-------------------------------
  xdg = {
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gnome
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-xapp
      ];
    };
  };

  #-------------------------------
  # 图形和硬件配置
  #-------------------------------
  hardware = {
    nvidia = {
      open = true;
      # package = config.boot.kernelPackages.nvidiaPackages.production;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        intel-compute-runtime
        nvidia-vaapi-driver
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };
    bluetooth.enable = true;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  #-------------------------------
  # 用户配置
  #-------------------------------
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;
  users.users.yoimiya = {
    isNormalUser = true;
    createHome = true;
    home = "/home/yoimiya";
    description = "Yoimiya";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "docker"
      "mlocate"
      "input"
      "adbusers"
      "video"
    ];
    packages = with pkgs; [
      vscode.fhs
    ];
  };

  #-------------------------------
  # 系统程序配置
  #-------------------------------
  programs = {
    adb.enable = true;
    firefox = {
      enable = true;
      wrapperConfig.pipewireSupport = true;
    };
    plotinus.enable = true;
    java.enable = true;
    dconf.enable = true;
    clash-verge = {
      enable = true;
      autoStart = false;
      package = pkgs.clash-verge-rev;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    nix-ld = {
      enable = true;
      libraries = pkgs.steam-run.args.multiPkgs pkgs;
    };
    virt-manager.enable = true;
  };

  #-------------------------------
  # 系统策略与设置
  #-------------------------------
  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cuda-maintainers.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  #-------------------------------
  # 环境变量
  #-------------------------------
  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      alejandra
      alacritty
      alacritty-theme
      anydesk
      aria2
      arphic-ukai
      arphic-uming
      autoconf
      autotiling
      bashInteractive
      bibata-cursors
      binutils
      binwalk
      bison
      bleachbit
      btop
      busybox
      cachix
      clang
      clang-tools
      clinfo
      cmake
      conda
      corefonts
      coreutils-full
      cowsay
      cppcheck
      # cudatoolkit
      devbox
      dnsutils
      # dotnet-sdk
      # dotnetCorePackages.sdk_9_0-bin
      dxvk
      edk2-uefi-shell
      elfutils
      # emacs
      ethtool
      exiftool
      eza
      fastfetch
      file
      filezilla
      findutils
      flex
      foliate
      fzf
      # gammastep
      # gawk
      gamemode
      gcc
      # gdb
      # ghostty
      gimp3
      git
      gitRepo
      glmark2
      glxinfo
      glow
      gnumake
      gnupg
      gnused
      gnutar
      # go
      # google-chrome
      gparted
      gperf
      gradle
      grim
      gnome-console
      gnome-characters
      gnome-disk-utility
      gnome-software
      gnome-terminal
      gnome-text-editor
      gnome-tweaks
      gnuchess
      gtk2
      gtk3
      gtk4
      hashcat
      hexo-cli
      hmcl
      htop
      hugo
      iftop
      imagemagick
      iperf3
      ipcalc
      jq
      # jetbrains.rust-rover
      # kdePackages.filelight
      kdePackages.full
      # kdePackages.qt6ct
      # kdePackages.qt6gtk2
      kdePackages.qtstyleplugin-kvantum
      kdePackages.xwaylandvideobridge
      kitty
      kitty-themes
      libva-utils
      ldns
      libguestfs
      libnotify
      # libreoffice-qt6-fresh
      libxkbcommon
      libxcrypt
      lldb
      lm_sensors
      # looking-glass-client
      lshw
      lsof
      ltrace
      m4
      mako
      marktext
      maven
      meson
      mediainfo
      mlocate
      motrix
      mpv
      mtr
      nautilus
      ncurses5
      # neofetch
      # networkmanagerapplet
      nil
      ninja
      # nixos-conf-editor
      # nix-output-monitor
      # nix-index-unwrapped
      ngrep
      # nix-software-center
      nmap
      # nodejs
      # nvtopPackages.full
      nnn
      # obsidian
      # openssl
      # openssl.dev
      orchis-theme
      pandoc
      papirus-icon-theme
      pciutils
      pdftk
      p7zip
      pkg-config
      plocate
      polkit_gnome
      powershell
      # prismlauncher
      procps
      # protonup-qt
      putty
      python3
      # qbittorrent-enhanced
      # qqmusic
      # qtcreator
      ripgrep
      # rofi
      rustup
      scrcpy
      # SDL2
      # sdl3
      # sdl3-ttf
      # sdl3-image
      # slurp
      socat
      spice-vdagent
      steam-run
      strace
      swtpm
      sysstat
      # termius
      # texliveFull
      tealdeer
      # thefuck
      # tigervnc
      tree
      # tmux
      # typescript
      # ubuntu-themes
      unrar
      unrar-wrapper
      unzip
      usbutils
      util-linux
      v2ray
      v2raya
      # v2rayn
      valgrind
      vdpauinfo
      vim
      vlc
      # vkd3d
      # vkd3d-proton
      # vulkan-tools
      wayland
      wayland-scanner
      wayland-protocols
      wget
      which
      whitesur-gtk-theme
      # wine64Packages.fonts
      # winePackages.fonts
      # wineWow64Packages.fonts
      # wineWowPackages.fonts
      # wineWowPackages.stagingFull
      # winetricks
      wl-clipboard
      wf-recorder
      # wpsoffice-cn
      wofi
      workstyle
      wqy_microhei
      wqy_zenhei
      xclip
      xfce.thunar
      xorg.xcalc
      xorg.xeyes
      xorg.xhost
      xz
      yaru-theme
      yt-dlp
      yq-go
      zathura
      zenity
      zip
      zotero
      zstd
      (
        (pkgs.ffmpeg-full.override {
          withUnfree = true;
          withOpengl = true;
        }).overrideAttrs
        (_: {
          doCheck = false;
        })
      )
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      })
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      gst_all_1.gst-vaapi

    ];
    variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "ibus";
      MOZ_ENABLE_WAYLAND = "1";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      EDITOR = "vim";
      LIBVA_DRIVER_NAME = "iHD";
    };
    sessionVariables = {
      # NIXOS_OZONE_WL = "1";
    };
  };

  #-------------------------------
  # 字体配置
  #-------------------------------
  system.userActivationScripts = {
    copy-fonts-local-share = {
      text = ''
        rm -rf ~/.local/share/fonts
        mkdir -p ~/.local/share/fonts
        cp ${pkgs.corefonts}/share/fonts/truetype/* ~/.local/share/fonts/
        chmod 544 ~/.local/share/fonts
        chmod 444 ~/.local/share/fonts/*
      '';
    };
  };

  fonts = {
    fontconfig.useEmbeddedBitmaps = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      maple-mono.CN-unhinted
      nerd-fonts.comic-shanns-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.ubuntu-mono
    ];
    fontconfig = {
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <!-- Replace NewCenturySchlbk font with TeX Gyre Schola. -->
          <match target="pattern">
            <test qual="any" name="family"><string>NewCenturySchlbk</string></test>
            <edit name="family" mode="assign" binding="same"><string>TeX Gyre Schola</string></edit>
          </match>

          <!-- Set font aliases for different language CJK fonts. -->
          <alias>
            <family>sans-serif</family>
            <prefer>
              <family>Noto Sans CJK SC</family> <!-- 简体中文 -->
              <family>Noto Sans CJK TC</family> <!-- 繁体中文 -->
              <family>Noto Sans CJK HK</family> <!-- 香港繁体中文 -->
              <family>Noto Sans CJK KR</family> <!-- 韩文 -->
              <family>Noto Sans CJK JP</family> <!-- 日文 -->
            </prefer>
          </alias>

          <alias>
            <family>serif</family>
            <prefer>
              <family>Noto Serif CJK SC</family> <!-- 简体中文 -->
              <family>Noto Serif CJK TC</family> <!-- 繁体中文 -->
              <family>Noto Serif CJK HK</family> <!-- 香港繁体中文 -->
              <family>Noto Serif CJK KR</family> <!-- 韩文 -->
              <family>Noto Serif CJK JP</family> <!-- 日文 -->
            </prefer>
          </alias>

          <alias>
            <family>monospace</family>
            <prefer>
              <family>Noto Sans Mono CJK SC</family> <!-- 简体中文 -->
              <family>Noto Sans Mono CJK TC</family> <!-- 繁体中文 -->
              <family>Noto Sans Mono CJK HK</family> <!-- 香港繁体中文 -->
              <family>Noto Sans Mono CJK KR</family> <!-- 韩文 -->
              <family>Noto Sans Mono CJK JP</family> <!-- 日文 -->
            </prefer>
          </alias>
        </fontconfig>
      '';
    };
  };

  #-------------------------------
  # 系统维护与垃圾回收
  #-------------------------------
  nix.gc = {
    automatic = true;
    dates = "12:00";
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  #-------------------------------
  # 虚拟内存配置
  #-------------------------------
  zramSwap.enable = true;

  #-------------------------------
  # 内核配置
  #-------------------------------
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
    kernel.sysctl = {
      "kernel.sysrq" = 1;
      "vm.max_map_count" = 2147483642;
      "fs.file-max" = 524288;
    };
    kernelPatches = [
      {
        name = "Rust Support";
        patch = null;
        features.rust = true;
      }
    ];
    extraModprobeConfig = lib.mkMerge [
      "options kvm_intel nested=1"
    ];
    kernelParams = lib.mkMerge [
      [
        "quiet"
        "splash"
        "usbcore.blinkenlights=1"
        "qxl"
        "virtio-gpu"
        "virtio"
        "virtio_scsi"
        "virtio_blk"
        "virtio_pci"
        "virtio_net"
        "virtio_ring"
      ]
    ];
  };

  #-------------------------------
  # 虚拟化配置
  #-------------------------------
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
    waydroid.enable = false;
    docker = {
      enable = false;
      daemon.settings.features = {
        "containerd-snapshotter" = true;
      };
      enableOnBoot = true;
    };
  };

  #-------------------------------
  # 系统服务
  #-------------------------------
  systemd.services = {
    flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      '';
    };
    v2ray = {
      description = "V2Ray Service";
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.v2ray}/bin/v2ray run";
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  #-------------------------------
  # 系统版本
  #-------------------------------
  system.stateVersion = "25.05"; # 首次安装时的版本
}


