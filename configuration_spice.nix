# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];


  # Enable OpenGL
  hardware.opengl = {
    enable = true;
  };

  # Bootloader configuration.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking configuration.
  networking.hostName = "nixos"; # Define your hostname.
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

  # Enable the X11 windowing system with the modesetting video driver.
  services.xserver.videoDrivers = [ "modesetting" ];

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
  programs.fish.enable = true;
  users.users.yoimiya = {
    isNormalUser = true;
    description = "Yoimiya";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # thunderbird
      vscode
    ];
  };
  
  # Install Firefox.
  programs.firefox.enable = true;

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  hardware.opengl.driSupport32Bit = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    spice-vdagent
    bleachbit
    vim
    vlc
    git
    llvm
    lldb
    # firefox
    libguestfs
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    gnome.gnome-tweaks
    xdg-desktop-portal-gnome
    # fish
    appimage-run
    v2ray
    v2raya
    fastfetch
    # vscode-with-extensions
    jdk
    gcc
    rustup
    cmake
    python3
    nodejs
    gedit
    go
    # conda
  
    # Extensions
    gnomeExtensions.dash-to-dock
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
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      gyre-fonts
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
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ libpinyin mozc ];
  };

  nix.gc.automatic = true;
  nix.gc.dates = "12:00";

  boot.kernelParams = [
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
  ];
  
  # boot.kernelPatches = [
  #   {
  #     name = "Rust Support";
  #     patch = null;
  #     features = {
  #       rust = true;
  #     };
  #   }
  # ];

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable Spice for virtual machines.
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

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

