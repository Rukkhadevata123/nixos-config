{
  config,
  pkgs,
  ...
}: {
  # 基本配置
  home.username = "yoimiya";
  home.homeDirectory = "/home/yoimiya";
  home.stateVersion = "25.05"; # 请不要轻易更改
  programs.home-manager.enable = true;

  # Git 配置
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Rukkhadevata123";
    userEmail = "3230102179@zju.edu.cn";
  };

  # Zsh 配置
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    };
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

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

    history = {
      size = 10000;
      ignoreAllDups = true;
      path = "$HOME/.zsh_history";
      ignorePatterns = ["rm *" "pkill *" "cp *"];
    };

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "python" "man" "thefuck"];
      theme = "robbyrussell";
    };
  };

  # 服务配置
  services = {
    cliphist.enable = true;
    flameshot.enable = true;

    wob = {
      enable = true;
      settings = {
        "" = {
          border_size = 10;
          height = 50;
        };
        "style.muted".background_color = "032cfc";
      };
    };

    swayidle = {
      enable = true;
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
  };

  # Wayland 相关程序配置
  programs = {
    wlogout = {
      enable = true;
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

        #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
        #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
        #suspend { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
        #hibernate { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png")); }
        #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
        #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
      '';
    };

    swaylock = {
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

    foot = {
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
  };

  # Sway 窗口管理器配置
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    checkConfig = false;
    extraOptions = ["--verbose" "--debug" "--unsupported-gpu"];

    config = {
      modifier = "Mod4"; # 使用 Super 键
      terminal = "foot";
      menu = "rofi -show run";

      bars = [
        {
          command = "\${pkgs.waybar}/bin/waybar";
        }
      ];

      output = {
        "*" = {
          bg = "/home/yoimiya/nixos-config/wallpaper.jpg fill";
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
        "${mod}+v" = "splitv";
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
        "${mod}+Shift+x" = "exec wlogout";
        "${mod}+Escape" = "exec wlogout";

        # 自定义功能
        "${mod}+Shift+q" = "exec flameshot gui";

        # 亮度控制
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

        # 音量控制
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # 剪贴板管理
        "${mod}+Shift+v" = "exec cliphist list | wofi -S dmenu | cliphist decode | wl-copy";
        "${mod}+Shift+Delete" = "exec cliphist wipe";
      };

      startup = [
        {
          command = "fcitx5 -d";
          always = true;
        }
        {
          command = "gammastep -O 4500 &";
          always = true;
        }
        {
          command = "nm-applet --indicator";
          always = true;
        }
        {
          command = "clash-verge &";
          always = false;
        }
        {
          command = "exec wl-paste --watch cliphist store";
          always = true;
        }
        {
          command = "blueman-applet";
          always = true;
        }
        {
          command = "echo 'Xft.dpi: 144' | xrdb -merge";
          always = true;
        }
      ];
    };
  };
}
