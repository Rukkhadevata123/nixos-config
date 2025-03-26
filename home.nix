{
  config,
  pkgs,
  ...
}:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
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
        ll = "ls -l";
        edit = "sudo -e";
        update = "sudo nixos-rebuild switch --upgrade";
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

