{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # 添加 nixvim 作为输入
    nixvim = {
      url = "github:nix-community/nixvim";
      # 确保 nixvim 使用与系统相同的 nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-alien 输入
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixvim,
    nix-alien,
    nix-software-center,
    nixos-conf-editor,
    ...
  }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          # nixvim 模块
          {
            imports = [nixvim.nixosModules.nixvim];
            programs.nixvim = {
              enable = true;
              colorschemes.catppuccin.enable = true;
              plugins.lualine.enable = true;
            };
          }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yoimiya = ./home.nix;
            home-manager.extraSpecialArgs = inputs;
          }
        ];
        # 传递所有输入到 configuration.nix
        specialArgs = { inherit inputs;};
      };
    };
  };
}