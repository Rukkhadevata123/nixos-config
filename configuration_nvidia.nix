# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./home.nix
  ];


  # Enable OpenGL
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  # };

  # Bootloader configuration.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    
    # Copy EDK2 Shell to boot partition
    systemd-boot.extraFiles."efi/shell.efi" = "${pkgs.edk2-uefi-shell}/shell.efi";
    systemd-boot.extraEntries = {
      # Chainload Windows bootloader via EDK2 Shell
      "windows.conf" =
        let
          # To determine the name of the windows boot drive, boot into edk2 first, then run
          # `map -c` to get drive aliases, and try out running `FS1:`, then `ls EFI` to check
          # which alias corresponds to which EFI partition.
          boot-drive = "FS2";
        in
        ''
          title Windows Bootloader
          efi /efi/shell.efi
          options -nointerrupt -nomap -noversion ${boot-drive}:EFI\Microsoft\Boot\Bootmgfw.efi
          sort-key y_windows
        '';
      # Make EDK2 Shell available as a boot option
      "edk2-uefi-shell.conf" = ''
        title EDK2 UEFI Shell
        efi /efi/shell.efi
        sort-key z_edk2
      '';
    };
  };

  # Networking configuration.
  networking.hostName = "nixos"; # Define your hostname.
  networking.extraHosts =
    ''
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
    '';
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # Configure network proxy if necessary.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Enable networking.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  xdg.portal.wlr.enable = true;
  
  # xdg = {
  #   portal = {
  #     enable = true;
  #     extraPortals = with pkgs; [
  #       xdg-desktop-portal-wlr
  #       xdg-desktop-portal-gtk
  #    ];
  #   };
  # };

  # Enable the X11 windowing system with the modesetting video driver.
  # services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics.enable32Bit = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently "beta quality", so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  
  hardware.nvidia.prime = {
  
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
      
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0"; # Specify the PCI address of the Nvidia GPU.
  };
  
  # Other nix binary caches.
  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with PipeWire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Uncomment if you want to use JACK applications.
    # jack.enable = true;
    # Enable the example session manager (no others are packaged yet).
    # media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # programs.fish.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.yoimiya = {
    isNormalUser = true;
    createHome = true;
    home = "/home/yoimiya";
    description = "Yoimiya";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "mlocate" ];
    # shell = pkgs.fish;
    packages = with pkgs; [
      # thunderbird
      vscode.fhs
      qq
      jetbrains.pycharm-professional
      jetbrains.idea-ultimate
      jetbrains.clion
      jetbrains.rust-rover
      jetbrains.goland
      # wechat-uos
      # wpsoffice-cn
    ];
  };
  
  # Install Firefox.
  programs.firefox.enable = true;
  
  programs.thunderbird.enable = true;
  
  programs.dconf.enable = true;
  
  programs.firefox.wrapperConfig = {
    pipewireSupport = true;
  };
  
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  
  # programs.bash = {
  #   interactiveShellInit = ''
  #     if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
  #     then
  #       shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
  #       exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
  #     fi
  #   '';
  # };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    ohMyZsh = {
      enable = true;
      plugins = ["git" "thefuck"];
      theme = "candy";
    };
  };
  
  environment.variables.EDITOR = "nvim";
  environment.variables.MOZ_ENABLE_WAYLAND = "1";
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set nocompatible
        set spell
        set spelllang=en_us
        set showmatch
        set ignorecase
        set list
        set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
        set smartcase
        set hlsearch
        set incsearch
        set mouse=a
        set tabstop=4
        set softtabstop=4
        set shiftwidth=4
        set expandtab
        set autoindent
        set number
        set relativenumber
        set splitright
        set splitbelow
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
        set clipboard=unnamedplus
        set cursorline
        set nowrap
        set termguicolors
        set signcolumn=yes
        filetype plugin indent on
        colorscheme tokyonight-moon
        hi NonText ctermbg=NONE guibg=NONE
        hi Normal guibg=NONE ctermbg=NONE
        hi NormalNC guibg=NONE ctermbg=NONE
        hi SignColumn ctermbg=NONE ctermfg=NONE guibg=NONE
        hi Pmenu ctermbg=NONE ctermfg=NONE guibg=NONE
        hi FloatBorder ctermbg=NONE ctermfg=NONE guibg=NONE
        hi NormalFloat ctermbg=NONE ctermfg=NONE guibg=NONE
        hi TabLine ctermbg=NONE ctermfg=NONE guibg=NONE
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ vim-bufferline ctrlp tokyonight-nvim nvim-tree-lua copilot-vim nvim-treesitter ];
      };
    };
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;
  
  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab  {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "triple-buffering-v4-46";
            hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
          };
        });
      });
    })
  ];

  programs.nix-ld = {
    enable = true;
    libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
  };
  
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   SDL
  #   SDL2
  #   SDL2_image
  #   SDL2_mixer
  #   SDL2_ttf
  #   SDL_image
  #   SDL_mixer
  #   SDL_ttf
  #   acl
  #   alsa-lib
  #   at-spi2-atk
  #   at-spi2-core
  #   attr
  #   atk
  #   bzip2
  #   cairo
  #   cups
  #   curl
  #   curlWithGnuTls
  #   dbus
  #   dbus-glib
  #   desktop-file-utils
  #   e2fsprogs
  #   expat
  #   flac
  #   fontconfig
  #   freeglut
  #   freetype
  #   fribidi
  #   fuse
  #   fuse3
  #   gdk-pixbuf
  #   glew110
  #   glib
  #   gmp
  #   gst_all_1.gst-plugins-base
  #   gst_all_1.gst-plugins-ugly
  #   gst_all_1.gstreamer
  #   gtk2
  #   harfbuzz
  #   icu
  #   keyutils.lib
  #   libGL
  #   libGLU
  #   libappindicator-gtk2
  #   libcaca
  #   libcanberra
  #   libcap
  #   libclang.lib
  #   libdbusmenu
  #   libdrm
  #   libgcrypt
  #   libgpg-error
  #   libidn
  #   libjack2
  #   libjpeg
  #   libmikmod
  #   libogg
  #   libpng12
  #   libpulseaudio
  #   librsvg
  #   libsamplerate
  #   libsodium
  #   libssh
  #   libthai
  #   libtheora
  #   libtiff
  #   libudev0-shim
  #   libusb1
  #   libuuid
  #   libvdpau
  #   libvorbis
  #   libvpx
  #   libxcrypt-legacy
  #   libxkbcommon
  #   libxml2
  #   mesa
  #   ncurses5
  #   nspr
  #   nss
  #   openssl
  #   p11-kit
  #   pango
  #   pixman
  #   python3
  #   speex
  #   systemd
  #   util-linux
  #   stdenv.cc.cc
  #   tbb
  #   udev
  #   vulkan-loader
  #   wayland
  #   xorg.libICE
  #   xorg.libSM
  #   xorg.libX11
  #   xorg.libXScrnSaver
  #   xorg.libXcomposite
  #   xorg.libXcursor
  #   xorg.libXdamage
  #   xorg.libXext
  #   xorg.libXfixes
  #   xorg.libXft
  #   xorg.libXi
  #   xorg.libXinerama
  #   xorg.libXmu
  #   xorg.libXrandr
  #   xorg.libXrender
  #   xorg.libXt
  #   xorg.libXtst
  #   xorg.libXxf86vm
  #   xorg.libpciaccess
  #   xorg.libxcb
  #   xorg.xcbutil
  #   xorg.xcbutilimage
  #   xorg.xcbutilkeysyms
  #   xorg.xcbutilrenderutil
  #   xorg.xcbutilwm
  #   xorg.xkeyboardconfig
  #   xz
  #   zlib
  #   zstd
  # ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    lshw
    bleachbit
    vulkan-tools
    busybox
    gimp
    imagemagick
    emacs
    jq
    coreutils
    xclip
    valgrind
    vim
    gdb
    vlc
    # git
    # libclang
    # clang
    # clang-tools
    # llvm
    lldb
    # firefox
    libguestfs
    # noto-fonts-cjk-sans
    # noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    gnome-tweaks
    xorg.xhost
    # findutils
    mlocate # sudo addgroup mlocate
    # xdg-desktop-portal-gnome
    # fish
    appimage-run
    v2ray
    v2raya
    fastfetch
    # vscode-with-extensions
    jdk
    maven
    gradle
    gcc
    rustup
    edk2-uefi-shell
    cmake
    eza
    python3
    nodejs
    hexo-cli
    gedit
    go
    prismlauncher
    # corefonts
    protonup-qt
    zlib
    openssl.dev
    pkg-config
    wqy_zenhei
    wqy_microhei
    # liberation_ttf_v1
    p7zip
    glxinfo
    # wineWowPackages.staging
    # wineWowPackages.waylandFull
    # wineWowPackages.unstableFull
    wineWowPackages.stagingFull
    wineWowPackages.fonts
    wineWow64Packages.fonts
    winePackages.fonts
    wine64Packages.fonts
    winetricks
    glmark2
    arphic-ukai
    arphic-uming
    texliveFull
    conda
    gitRepo
    gnupg
    autoconf
    # curl
    procps
    gnumake
    util-linux
    m4
    gperf
    unzip
    # cudatoolkit
    # cudaPackages.cudatoolkit
    cachix
    # linuxPackages.nvidia_x11
    # libGLU
    # libGL
    # xorg.libXi
    # xorg.libXmu
    # freeglut
    # xorg.libXext
    # xorg.libX11
    # xorg.libXv
    # xorg.libXrandr
    # ncurses5
    orchis-theme
    bibata-cursors
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qt6ct
    papirus-icon-theme
    stdenv.cc
    binutils
    htop
    bashInteractive
    obsidian
    ninja
    onlyoffice-bin
    thefuck
    pandoc
    wl-clipboard
    # thunderbird # 24.05
    filezilla
    motrix
    llvmPackages_latest.llvm
    # neovim
    kdePackages.filelight
    yesplaymusic
    ((pkgs.ffmpeg-full.override { withUnfree = true; withOpengl = true; }).overrideAttrs (_: { doCheck = false; }))
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    (chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
    
    # Extensions
    gnomeExtensions.dash-to-dock
    gnomeExtensions.lunar-calendar
    gnomeExtensions.gsconnect
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.coverflow-alt-tab
    gnomeExtensions.extension-list
    gnomeExtensions.appindicator
    # gnomeExtensions.auto-move-windows
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    # gnomeExtensions.launch-new-instance
    # gnomeExtensions.user-themes
    gnomeExtensions.vitals
    # gnomeExtensions.easyScreenCast
    # gnomeExtensions.fuzzy-app-search
    gnomeExtensions.just-perfection
    gnomeExtensions.user-avatar-in-quick-settings
    gnomeExtensions.weather-oclock
    gnomeExtensions.arcmenu
    gnomeExtensions.gnome-40-ui-improvements
    gnomeExtensions.legacy-gtk3-theme-scheme-auto-switcher
    # gnomeExtensions.light-style
    # gnomeExtensions.removable-drive-menu
    # gnomeExtensions.screenshot-window-sizer
  ];
  # Font packages configuration.
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      gyre-fonts
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Ubuntu" "JetBrainsMono" "0xProto" "Meslo" ]; })
    ];

    # Custom fontconfig configuration.
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

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ libpinyin mozc ];
  };

  # Auto delete old generations.
  nix.gc.automatic = true;
  nix.gc.dates = "12:00";

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "vm.max_map_count" = 2147483642;
    "fs.file-max" = 524288;
  };
  boot.kernelParams = [
    "quiet"
    "splash"
    "usbcore.blinkenlights=1"
  ];
  
  boot.kernelPatches = [
    {
      name = "Rust Support";
      patch = null;
      features = {
        rust = false;
      };
    }
  ];

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # V2Ray service configuration.
  systemd.services.v2ray = {
    description = "V2Ray Service";
    after = [ "network.target" ];  # Run after network is up.
    
    serviceConfig = {
      ExecStart = "${pkgs.v2ray}/bin/v2ray run";  # Start V2Ray.
      Restart = "always";  # Restart on failure.
    };

    wantedBy = [ "multi-user.target" ];  # Run in multi-user mode.
  };
  
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.vmware.host.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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
  # on your system were taken. It’s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value, read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

  # export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'
  # export LD_LIBRARY_PATH=$(find /nix/store -type d -name '*steam-run-fhs*' -exec echo -n {}'/usr/lib32:'{}'/usr/lib64:' \;)



