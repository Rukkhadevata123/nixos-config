{
  config,
  pkgs,
  ...
}: {
  # 注意修改这里的用户名与用户目录
  home.username = "yoimiya";
  home.homeDirectory = "/home/yoimiya";

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # 递归整个文件夹
  #   executable = true;  # 将其中所有文件添加「执行」权限
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  #   home.packages = with pkgs; [
  #     # 如下是我常用的一些命令行工具，你可以根据自己的需要进行增删
  #     neofetch
  #     nnn # terminal file manager

  #     # archives
  #     zip
  #     xz
  #     unzip
  #     p7zip

  #     # utils
  #     ripgrep # recursively searches directories for a regex pattern
  #     jq # A lightweight and flexible command-line JSON processor
  #     yq-go # yaml processor https://github.com/mikefarah/yq
  #     eza # A modern replacement for ‘ls’
  #     fzf # A command-line fuzzy finder

  #     # networking tools
  #     mtr # A network diagnostic tool
  #     iperf3
  #     dnsutils # `dig` + `nslookup`
  #     ldns # replacement of `dig`, it provide the command `drill`
  #     aria2 # A lightweight multi-protocol & multi-source command-line download utility
  #     socat # replacement of openbsd-netcat
  #     nmap # A utility for network discovery and security auditing
  #     ipcalc # it is a calculator for the IPv4/v6 addresses

  #     # misc
  #     cowsay
  #     file
  #     which
  #     tree
  #     gnused
  #     gnutar
  #     gawk
  #     zstd
  #     gnupg

  #     # nix related
  #     #
  #     # it provides the command `nom` works just like `nix`
  #     # with more details log output
  #     nix-output-monitor

  #     # productivity
  #     hugo # static site generator
  #     glow # markdown previewer in terminal

  #     btop # replacement of htop/nmon
  #     iotop # io monitoring
  #     iftop # network monitoring

  #     # system call monitoring
  #     strace # system call monitoring
  #     ltrace # library call monitoring
  #     lsof # list open files

  #     # system tools
  #     sysstat
  #     lm_sensors # for `sensors` command
  #     ethtool
  #     pciutils # lspci
  #     usbutils # lsusb
  #   ];

  # git 相关配置
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Rukkhadevata123";
    userEmail = "3230102179@zju.edu.cn";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autosuggestion.highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    syntaxHighlighting.enable = true;

    shellAliases = {
      la = "ls -A";
      ll = "ls -l";
      edit = "sudo -e";
      cpconfig = "sudo cp ~/nixos-config/home.nix /etc/nixos/home.nix && sudo cp ~/nixos-config/configuration.nix /etc/nixos/configuration.nix && sudo cp ~/nixos-config/flake.nix /etc/nixos/flake.nix";
      update = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --upgrade";
      garbage = "sudo nix-collect-garbage -d";
      rm = "rm -i";
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gpl = "git pull";
      gst = "git stash";
      gsp = "git stash; git pull";
      gcheck = "git checkout";
      gcredential = "git config credential.helper store";
      cp = "cp -i";
      df = "df -h";
      free = "free -m";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
      ip = "ip --color=auto";
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = [
      "rm *"
      "pkill *"
      "cp *"
    ];
    historySubstringSearch.enable = true;
    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = ["git" "python" "man" "thefuck"];
    oh-my-zsh.theme = "robbyrussell";
  };
  services.cliphist.enable = true;
  services.flameshot.enable = true;
  services.wob = {
    enable = true;
    settings = {
      "" = {
        border_size = 10;
        height = 50;
      };
      "style.muted".background_color = "032cfc";
    };
  };
  programs.wlogout = {
    enable = true;
    # 自定义布局和样式
    layout = [
      {
        label = "lock";
        action = "swaylock -f -c 000000";
        text = "锁定";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "休眠";
        keybind = "h";
      }
      {
        label = "logout";
        action = "swaymsg exit";
        text = "注销";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "关机";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "睡眠";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "重启";
        keybind = "r";
      }
    ];
    style = ''
      * {
        background-image: none;
      }
      window {
        background-color: rgba(12, 12, 12, 0.9);
      }
      button {
        color: #FFFFFF;
        background-color: #1E1E1E;
        border-style: solid;
        border-width: 2px;
        border-color: #444444;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-radius: 8px;
        margin: 5px;
        box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.4);
      }

      button:focus, button:active, button:hover {
        background-color: #3700B3;
        border-color: #BB86FC;
        color: #FFFFFF;
        outline-style: none;
      }

      #lock {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }
    '';
  };
  programs.swaylock = {
    enable = true;
    settings = {
      color = "808080";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
    };
  };
  services.swayidle = {
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
      {
        timeout = 1200;
        command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on\"";
      }
    ];
  };
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    checkConfig = false;
    extraOptions = [
      "--verbose"
      "--debug"
      "--unsupported-gpu"
    ];

    config = {
      modifier = "Mod4"; # 使用 Super 键
      terminal = "foot";
      menu = "rofi -show run"; # 启动器
      bars = [
        {
          command = "\${pkgs.waybar}/bin/waybar";
        }
      ];
      output = {
        "*" = {
          bg = "/home/yoimiya/nixos-config/wallpaper.jpg fill"; # 使用系统内置壁纸
          scale = "1";
        };
      };
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
      in {
        # 工作区切换
        "${mod}+0" = "workspace number 10";
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";

        # 窗口焦点移动
        "${mod}+Down" = "focus down";
        "${mod}+Left" = "focus left";
        "${mod}+Right" = "focus right";
        "${mod}+Up" = "focus up";
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+a" = "focus parent";
        "${mod}+space" = "focus mode_toggle";

        # 窗口移动
        "${mod}+Shift+0" = "move container to workspace number 10";
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Right" = "move right";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # 布局与窗口管理
        "${mod}+b" = "splith";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+s" = "layout stacking";
        "${mod}+v" = "splitv"; # 保留原始布局功能
        "${mod}+w" = "layout tabbed";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";

        # 基本操作
        "${mod}+Return" = "exec foot";
        "${mod}+d" = "exec wofi --show drun";
        "${mod}+r" = "mode resize";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${mod}+q" = "kill";

        # 登出
        "${mod}+Shift+x" = "exec wlogout"; # 使用 Super+Shift+x 调出退出菜单
        "${mod}+Escape" = "exec wlogout"; # 可选的另一个快捷键

        # 自定义功能
        "${mod}+Shift+q" = "exec flameshot gui"; # 截图工具

        # 亮度控制
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

        # 音量控制
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # 剪贴板管理（调整后的快捷键）
        "${mod}+Shift+v" = "exec cliphist list | wofi -S dmenu | cliphist decode | wl-copy";
        "${mod}+Shift+Delete" = "exec cliphist wipe";
      };
      startup = [
        # 启动 fcitx5 并等待它完成初始化
        {
          command = "fcitx5 -d";
          always = true;
        }
        # 启动 redshift 并使用指定色温
        {
          command = "gammastep -O 4500 &";
          always = true;
        }
        # 网络连接
        {
          command = "nm-applet --indicator";
          always = true;
        }
        # 启动代理
        {
          command = "clash-verge &";
          always = false;
        }
        # 剪贴板管理
        {
          command = "exec wl-paste --watch cliphist store";
          always = true;
        }
        # 启动蓝牙
        {
          command = "blueman-applet";
          always = true;
        }
        # Xwayland缩放
        {
          command = "echo 'Xft.dpi: 144' | xrdb -merge";
          always = true;
        }
      ];
    };
  };

  # Foot 终端配置
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        dpi-aware = "yes";
      };
      colors = {
        background = "1d2021";
        foreground = "d4be98";
      };
    };
  };
  # 启用 starship，这是一个漂亮的 shell 提示符
  #   programs.starship = {
  #     enable = true;
  #     # 自定义配置
  #     settings = {
  #       add_newline = false;
  #       aws.disabled = true;
  #       gcloud.disabled = true;
  #       line_break.disabled = true;
  #     };
  #   };

  # alacritty - 一个跨平台终端，带 GPU 加速功能
  #   programs.alacritty = {
  #     enable = true;
  #     # 自定义配置
  #     settings = {
  #       env.TERM = "xterm-256color";
  #       font = {
  #         size = 12;
  #         draw_bold_text_with_bright_colors = true;
  #       };
  #       scrolling.multiplier = 5;
  #       selection.save_to_clipboard = true;
  #     };
  #   };

  #   programs.bash = {
  #     enable = true;
  #     enableCompletion = true;
  #     # TODO 在这里添加你的自定义 bashrc 内容
  #     bashrcExtra = ''
  #       export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
  #     '';

  #     # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
  #     shellAliases = {
  #       k = "kubectl";
  #       urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
  #       urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  #     };
  #   };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
