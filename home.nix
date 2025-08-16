{ config, pkgs, ... }:

{
  # 基本配置
  home.username = "yoimiya";
  home.homeDirectory = "/home/yoimiya";
  home.stateVersion = "25.05";

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
      update = "flatpak update && flatpak uninstall --unused && cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --upgrade";
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
      # ignorePatterns = ["rm *" "pkill *" "cp *"];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "man"
      ];
      theme = "robbyrussell";
    };
  };

  # 服务配置
  services = {
    cliphist.enable = true;
    flameshot.enable = true;
  };

}


