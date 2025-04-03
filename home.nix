{
  config,
  pkgs,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.yoimiya = {
    # The home.stateVersion option does not have a default and must be set
    home.stateVersion = "25.05";
    # home.enableNixpkgsReleaseCheck = false;
    programs.home-manager.enable = true;
    # Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
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
        cpconfig = "sudo cp ~/nixos-config/home.nix /etc/nixos/home.nix && sudo cp ~/nixos-config/configuration.nix /etc/nixos/configuration.nix";
        update = "sudo nixos-rebuild switch --upgrade";
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

    xdg = {
      portal = {
        enable = true;
        config.common.default = "*";
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-xapp
        ];
      };
    };
  };
}
