let
  # We pin to a specific nixpkgs commit for reproducibility.
  # Last updated: 2024-04-29. Check for new commits at https://status.nixos.org.
  pkgs = import (fetchTarball "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/bd3bac8bfb542dbde7ffffb6987a1a1f9d41699f.tar.gz") {};
in pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      # select Python packages here
      pandas
      requests
      matplotlib
      numpy
    ]))
  ];
}
