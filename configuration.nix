# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # 定义一个开关变量
  enableVFIO = false; # 设置为 true 使用直通配置，false 使用原始配置
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = false;
    grub.device = "nodev";
    grub.enable = true;
    grub.efiSupport = true;
    grub.efiInstallAsRemovable = true;
    grub.configurationName = "Unstable";
    grub.useOSProber = true;
    grub.memtest86.enable = true;
    grub.theme = "/etc/nixos/grubtheme/Tribbie";
    # efi.canTouchEfiVariables = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.extraHosts = ''
    # Honkai Impact 3rd analytics servers (glb/sea/tw/kr/jp):
    0.0.0.0 log-upload-os.hoyoverse.com
    0.0.0.0 sg-public-data-api.hoyoverse.com
    0.0.0.0 dump.gamesafe.qq.com

    # Honkai Impact 3rd analytics servers (cn):
    0.0.0.0 log-upload.mihoyo.com
    0.0.0.0 public-data-api.mihoyo.com
    0.0.0.0 dump.gamesafe.qq.com


    # Honkai Star Rail analytics servers (os)
    0.0.0.0 log-upload-os.hoyoverse.com
    0.0.0.0 sg-public-data-api.hoyoverse.com

    # Honkai Star Rail analytics servers (cn)
    0.0.0.0 log-upload.mihoyo.com
    0.0.0.0 public-data-api.mihoyo.com

    0.0.0.0 log-upload.mihoyo.com
    0.0.0.0 uspider.yuanshen.com
    0.0.0.0 ys-log-upload.mihoyo.com
    0.0.0.0 dispatchcnglobal.yuanshen.com
    # 0.0.0.0 webstatic.mihoyo.com
  '';
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.httpProxy = "http://127.0.0.1:7897";
  networking.proxy.httpsProxy = "http://127.0.0.1:7897";
  networking.proxy.allProxy = "socks5://127.0.0.1:7897";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-chinese-addons
    ];
    fcitx5.waylandFrontend = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.desktopManager.runXdgAutostartIfNone = true;
  services.gnome.games.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.redshift.enable = true;
  location.latitude = 30.26;
  location.longitude = 120.19;
  # services.redshift.temperature.night = 4500;
  # services.redshift.temperature.day = 4500;
  # services.redshift.brightness.night = 0.4;
  # services.redshift.brightness.day = 0.6;
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.locate.enable = true;
  services.locate.package = pkgs.mlocate;
  services.flatpak.enable = true;
  services.blueman.enable = true;
  services.kmscon = {
    # Use kmscon as the virtual console instead of gettys.
    # kmscon is a kms/dri-based userspace virtual terminal implementation.
    # It supports a richer feature set than the standard linux console VT,
    # including full unicode support, and when the video card supports drm should be much faster.
    enable = false;
    fonts = [
      {
        name = "Source Code Pro";
        package = pkgs.source-code-pro;
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=12";
    # Whether to use 3D hardware acceleration to render the console.
    hwRender = true;
  };
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
  # services.onlyoffice.enable = true;

  # About Graphics
  services.xserver.videoDrivers = ["modesetting" "nvidia"];
  hardware.nvidia.open = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
    intel-media-driver
    intel-vaapi-driver
  ];
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
    intel-compute-runtime
    nvidia-vaapi-driver
  ];
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0"; # Specify the PCI address of the Nvidia GPU.
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
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
      vscodium-fhs
      qq
      wechat-uos
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.adb.enable = true;
  programs.firefox.enable = true;
  programs.plotinus.enable = true;
  programs.java.enable = true;
  programs.dconf.enable = true;
  programs.clash-verge.enable = true;
  programs.clash-verge.autoStart = false;
  programs.clash-verge.package = pkgs.clash-verge-rev;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.waybar.enable = true;

  programs.firefox.wrapperConfig = {
    pipewireSupport = true;
  };

  # There have been amdgpu issues in 6.10 so you maybe need to revert on the default lts kernel.
  # boot.kernelPackages = pkgs.linuxPackages;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Run binaries
  programs.nix-ld = {
    enable = true;
    libraries = pkgs.steam-run.args.multiPkgs pkgs;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Other nix binary caches.
  nix.settings = {
    substituters = [
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # environment.variables.CPLUS_INCLUDE_PATH = "${stdenv.cc.cc}/include/c++/${stdenv.cc.cc.version}:${stdenv.cc.cc}/include/c++/${stdenv.cc.cc.version}/x86_64-unknown-linux-gnu:${stdenv.cc.cc}/lib/gcc/x86_64-unknown-linux-gnu/${stdenv.cc.cc.version}/include:${stdenv.cc.libc.dev}/include";
  # environment.variables.QT_QPA_PLATFORM_PLUGIN_PATH="${libsForQt5.qt5.qtbase}/lib/qt-${libsForQt5.qt5.qtbase.version}/plugins/platforms";
  # environment.variables.GTK3_MODULES = "${pkgs.plotinus}/lib/libplotinus.so";
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.shells = with pkgs; [zsh];
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    alejandra
    alacritty
    alacritty-theme
    anydesk
    appimage-run
    aria2
    arphic-ukai
    arphic-uming
    autoconf
    autotiling
    bashInteractive
    bibata-cursors
    binutils
    bison
    bleachbit
    brightnessctl
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
    cudatoolkit
    devbox
    dnsutils
    dotnet-sdk
    # dotnetCorePackages.sdk_9_0-bin
    dxvk
    edk2-uefi-shell
    elfutils
    emacs
    ethtool
    eza
    fastfetch
    file
    filezilla
    findutils
    flex
    foliate
    fzf
    gammastep
    gawk
    gamemode
    gcc
    gdb
    ghostty
    gimp
    git
    gitRepo
    glmark2
    glxinfo
    glow
    gnumake
    gnupg
    gnused
    gnutar
    go
    google-chrome
    gparted
    gperf
    gradle
    grim
    gnome-console
    gnome-disk-utility
    gnome-software
    gnome-terminal
    gnome-text-editor
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
    inputs.nix-alien.packages.${system}.nix-alien
    inputs.nixos-conf-editor.packages.${system}.nixos-conf-editor
    inputs.nix-software-center.packages.${system}.nix-software-center
    iperf3
    ipcalc
    jq
    kdePackages.filelight
    kdePackages.full
    kdePackages.qt6ct
    kdePackages.qt6gtk2
    kdePackages.qtstyleplugin-kvantum
    kdePackages.xwaylandvideobridge
    kitty
    kitty-themes
    libva-utils
    ldns
    libguestfs
    libnotify
    libreoffice-qt6-fresh
    libxcrypt
    lldb
    lm_sensors
    looking-glass-client
    lshw
    lsof
    ltrace
    m4
    mako
    marktext
    maven
    meson
    microsoft-edge
    mlocate
    motrix
    mpv
    mtr
    nautilus
    ncurses5
    neofetch
    networkmanagerapplet
    nil
    ninja
    # nixos-conf-editor
    nix-output-monitor
    # nix-software-center
    nmap
    nodejs
    nvtopPackages.full
    nnn
    obsidian
    openssl
    openssl.dev
    orchis-theme
    pandoc
    papirus-icon-theme
    pciutils
    p7zip
    pkg-config
    plocate
    polkit_gnome
    powershell
    prismlauncher
    procps
    protonup-qt
    putty
    python3
    qbittorrent-enhanced
    # qqmusic
    qtcreator
    ripgrep
    rofi
    rustup
    scrcpy
    slurp
    socat
    spice-vdagent
    steam-run
    strace
    swtpm
    sysstat
    termius
    texliveFull
    tealdeer
    thefuck
    tigervnc
    tree
    tmux
    typescript
    ubuntu-themes
    unrar
    unrar-wrapper
    unzip
    usbutils
    util-linux
    v2ray
    v2raya
    valgrind
    vdpauinfo
    vim
    vlc
    vkd3d
    vkd3d-proton
    vulkan-tools
    wget
    which
    whitesur-gtk-theme
    wine64Packages.fonts
    winePackages.fonts
    wineWow64Packages.fonts
    wineWowPackages.fonts
    wineWowPackages.stagingFull
    winetricks
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
      })
      .overrideAttrs
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
    # libsForQt5.full
    # libsForQt5.qt5ct
    # libsForQt5.qtstyleplugin-kvantum
    # libsForQt5.xwaylandvideobridge
    # cudaPackages.cudatoolkit
    # gns3-gui
    # gns3-server

    # libsForQt5.full
    # wineWowPackages.staging
    # wineWowPackages.waylandFull
    # wineWowPackages.unstableFull
    # libsForQt5.qt5.wrapQtAppsHook
    # libsForQt5.breeze-qt5
    # libsForQt5.breeze-gtk
    # libsForQt5.breeze-icons
    (chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
        "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
        "--enable-features=UseMultiPlaneFormatForHardwareVideo"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
  ];

  # Font packages configuration.
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
      corefonts
      dina-font
      fira-code
      fira-code-symbols
      gyre-fonts
      liberation_ttf
      lxgw-fusionkai
      lxgw-neoxihei
      lxgw-wenkai
      lxgw-wenkai-screen
      lxgw-wenkai-tc
      mplus-outline-fonts.githubRelease
      # Maple Mono (Ligature Variable)
      maple-mono.variable
      # Maple Mono (Ligature TTF hinted)
      maple-mono.truetype-autohint
      # Maple Mono (Ligature TTF unhinted)
      maple-mono.truetype
      # Maple Mono (Ligature OTF)
      maple-mono.opentype
      # Maple Mono (Ligature WOFF2)
      maple-mono.woff2
      # Maple Mono NF (Ligature hinted)
      maple-mono.NF
      # Maple Mono NF (Ligature unhinted)
      maple-mono.NF-unhinted
      # Maple Mono CN (Ligature hinted)
      maple-mono.CN
      # Maple Mono CN (Ligature unhinted)
      maple-mono.CN-unhinted
      # Maple Mono NF CN (Ligature hinted)
      maple-mono.NF-CN
      # Maple Mono NF CN (Ligature unhinted)
      maple-mono.NF-CN-unhinted

      # Maple Mono (No-Ligature Variable)
      maple-mono.NL-Variable
      # Maple Mono (No-Ligature TTF hinted)
      maple-mono.NL-TTF-AutoHint
      # Maple Mono (No-Ligature TTF unhinted)
      maple-mono.NL-TTF
      # Maple Mono (No-Ligature OTF)
      maple-mono.NL-OTF
      # Maple Mono (No-Ligature WOFF2)
      maple-mono.NL-Woff2
      # Maple Mono NF (No-Ligature hinted)
      maple-mono.NL-NF
      # Maple Mono NF (No-Ligature unhinted)
      maple-mono.NL-NF-unhinted
      # Maple Mono CN (No-Ligature hinted)
      maple-mono.NL-CN
      # Maple Mono CN (No-Ligature unhinted)
      maple-mono.NL-CN-unhinted
      # Maple Mono NF CN (No-Ligature hinted)
      maple-mono.NL-NF-CN
      # Maple Mono NF CN (No-Ligature unhinted)
      maple-mono.NL-NF-CN-unhinted

      # Maple Mono Normal (Ligature Variable)
      maple-mono.Normal-Variable
      # Maple Mono Normal (Ligature TTF hinted)
      maple-mono.Normal-TTF-AutoHint
      # Maple Mono Normal (Ligature TTF unhinted)
      maple-mono.Normal-TTF
      # Maple Mono Normal (Ligature OTF)
      maple-mono.Normal-OTF
      # Maple Mono Normal (Ligature WOFF2)
      maple-mono.Normal-Woff2
      # Maple Mono Normal NF (Ligature hinted)
      maple-mono.Normal-NF
      # Maple Mono Normal NF (Ligature unhinted)
      maple-mono.Normal-NF-unhinted
      # Maple Mono Normal CN (Ligature hinted)
      maple-mono.Normal-CN
      # Maple Mono Normal CN (Ligature unhinted)
      maple-mono.Normal-CN-unhinted
      # Maple Mono Normal NF CN (Ligature hinted)
      maple-mono.Normal-NF-CN
      # Maple Mono Normal NF CN (Ligature unhinted)
      maple-mono.Normal-NF-CN-unhinted

      # Maple Mono Normal (No-Ligature Variable)
      maple-mono.NormalNL-Variable
      # Maple Mono Normal (No-Ligature TTF hinted)
      maple-mono.NormalNL-TTF-AutoHint
      # Maple Mono Normal (No-Ligature TTF unhinted)
      maple-mono.NormalNL-TTF
      # Maple Mono Normal (No-Ligature OTF)
      maple-mono.NormalNL-OTF
      # Maple Mono Normal (No-Ligature WOFF2)
      maple-mono.NormalNL-Woff2
      # Maple Mono Normal NF (No-Ligature hinted)
      maple-mono.NormalNL-NF
      # Maple Mono Normal NF (No-Ligature unhinted)
      maple-mono.NormalNL-NF-unhinted
      # Maple Mono Normal CN (No-Ligature hinted)
      maple-mono.NormalNL-CN
      # Maple Mono Normal CN (No-Ligature unhinted)
      maple-mono.NormalNL-CN-unhinted
      # Maple Mono Normal NF CN (No-Ligature hinted)
      maple-mono.NormalNL-NF-CN
      # Maple Mono Normal NF CN (No-Ligature unhinted)
      maple-mono.NormalNL-NF-CN-unhinted
      nerd-fonts._0xproto
      nerd-fonts._3270
      nerd-fonts.agave
      nerd-fonts.anonymice
      nerd-fonts.arimo
      nerd-fonts.aurulent-sans-mono
      nerd-fonts.bigblue-terminal
      nerd-fonts.bitstream-vera-sans-mono
      nerd-fonts.blex-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts.caskaydia-mono
      nerd-fonts.code-new-roman
      nerd-fonts.comic-shanns-mono
      nerd-fonts.commit-mono
      nerd-fonts.cousine
      nerd-fonts.d2coding
      nerd-fonts.daddy-time-mono
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.departure-mono
      nerd-fonts.droid-sans-mono
      nerd-fonts.envy-code-r
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.geist-mono
      nerd-fonts.go-mono
      nerd-fonts.gohufont
      nerd-fonts.hack
      nerd-fonts.hasklug
      nerd-fonts.heavy-data
      nerd-fonts.hurmit
      nerd-fonts.im-writing
      nerd-fonts.inconsolata
      nerd-fonts.inconsolata-go
      nerd-fonts.inconsolata-lgc
      nerd-fonts.intone-mono
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.iosevka-term-slab
      nerd-fonts.jetbrains-mono
      nerd-fonts.lekton
      nerd-fonts.liberation
      nerd-fonts.lilex
      nerd-fonts.martian-mono
      nerd-fonts.meslo-lg
      nerd-fonts.monaspace
      nerd-fonts.monofur
      nerd-fonts.monoid
      nerd-fonts.mononoki
      nerd-fonts.mplus
      nerd-fonts.noto
      nerd-fonts.open-dyslexic
      nerd-fonts.overpass
      nerd-fonts.profont
      nerd-fonts.proggy-clean-tt
      nerd-fonts.recursive-mono
      nerd-fonts.roboto-mono
      nerd-fonts.sauce-code-pro
      nerd-fonts.shure-tech-mono
      nerd-fonts.space-mono
      nerd-fonts.symbols-only
      nerd-fonts.terminess-ttf
      nerd-fonts.tinos
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.ubuntu-sans
      nerd-fonts.victor-mono
      nerd-fonts.zed-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      proggyfonts
    ];
    # Custom fontconfig configuration.
    fontconfig = {
      #       defaultFonts = {
      #         serif = ["Source Han Serif SC" "Source Han Serif TC" "Noto Color Emoji"];
      #         sansSerif = ["Source Han Sans SC" "Source Han Sans TC" "Noto Color Emoji"];
      #         monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      #         emoji = ["Noto Color Emoji"];
      #       };

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

  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    MOZ_ENABLE_WAYLAND = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    EDITOR = "vim";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # Auto delete old generations.
  nix.gc.automatic = true;
  nix.gc.dates = "12:00";

  # Zram
  zramSwap.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [kvmfr];
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "vm.max_map_count" = 2147483642;
    "fs.file-max" = 524288;
  };

  boot.kernelPatches = [
    {
      name = "Rust Support";
      patch = null;
      features = {
        rust = true;
      };
    }
  ];

  # 公共配置 (无论enableVFIO为何值都会生效)
  boot.extraModprobeConfig = lib.mkMerge [
    "options kvm_intel nested=1"
    (lib.mkIf enableVFIO ''
      options vfio-pci ids=10de:28e1,10de:22be
      softdep nvidia pre: vfio-pci
      options kvmfr static_size_mb=32
    '')
  ];

  boot.kernelParams = lib.mkMerge [
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
    (lib.mkIf enableVFIO [
      "intel_iommu=on"
      "iommu=pt"
      "vfio_pci.ids=10de:28e1,10de:22be"
      "vfio_iommu_type1.allow_unsafe_interrupts=1"
      "kvm.ignore_msrs=1"
    ])
  ];

  # 仅在enableVFIO为true时添加的配置
  boot.initrd.kernelModules = lib.mkIf enableVFIO [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;
  # virtualisation.vmware.host.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
    ovmf.packages = [pkgs.OVMFFull.fd];
  };
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      # enables pulling using containerd, which supports restarting from a partial pull
      # https://docs.docker.com/storage/containerd/
      "features" = {"containerd-snapshotter" = true;};
    };

    # start dockerd on boot.
    # This is required for containers which are created with the `--restart=always` flag to work.
    enableOnBoot = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  # Flathub
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # V2Ray service configuration.
  systemd.services.v2ray = {
    description = "V2Ray Service";
    after = ["network.target"]; # Run after network is up.

    serviceConfig = {
      ExecStart = "${pkgs.v2ray}/bin/v2ray run"; # Start V2Ray.
      Restart = "always"; # Restart on failure.
    };

    wantedBy = ["multi-user.target"]; # Run in multi-user mode.
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
# export LD_LIBRARY_PATH=$(find /nix/store -type d -name '*steam-run-fhs*' -exec echo -n {}'/usr/lib32:'{}'/usr/lib64:' \;):$(find /nix/store -type d -name '*qtbase*' -exec echo -n {}'/lib:' \;)
# kgx --tab
# nix-shell -p ncurses5 flex bison elfutils openssl # kernel
# nix-shell -p gtk4 gtk3 pkg-config # rust-gtk

