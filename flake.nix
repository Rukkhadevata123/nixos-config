{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixvim,
    nix-alien,
    nix-software-center,
    nixos-conf-editor,
    nur,
    ...
  }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = let
          system = "x86_64-linux";
        in [
          ./configuration.nix

          # Home Manager 配置
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yoimiya = ./home.nix;
            home-manager.extraSpecialArgs = inputs;
          }

          # Nixvim 配置
          nixvim.nixosModules.nixvim
          {
            programs.nixvim = {
              enable = true;
              colorschemes.catppuccin.enable = true;
              plugins.lualine.enable = true;
              plugins.copilot-vim = let
                pkgs = import nixpkgs {
                  inherit system;
                  config.allowUnfree = true;
                };
              in {
                enable = true;
                package = pkgs.vimPlugins.copilot-vim;
              };
            };
          }

          # NUR 配置
          nur.modules.nixos.default
          nur.legacyPackages."${system}".repos.iopq.modules.xraya

          # NUR 包
          ({pkgs, ...}: {
            environment.systemPackages = [
              pkgs.nur.repos.mic92.hello-nur
              pkgs.nur.repos.novel2430.wpsoffice-365
              pkgs.nur.repos.rewine.ttf-wps-fonts
            ];
          })
        ];

        # 传递所有输入到 configuration.nix
        specialArgs = {inherit inputs;};
      };
    };
  };
}
