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
    home.stateVersion = "24.11";
    # home.enableNixpkgsReleaseCheck = false;
    programs.home-manager.enable = true;
    # Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "Rukkhadevata123";
      userEmail = "3230102179@zju.edu.cn";
    };

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
      style.name = "qt6gtk2"; # breeze gtk2
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };

    # xdg.configFile = {
    #   "Kvantum/ArcDark".source = "${pkgs.arc-kde-theme}/share/Kvantum/ArcDark";
    #   "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=ArcDark";
    # };
  };
}
