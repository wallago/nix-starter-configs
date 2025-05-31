{ outputs, inputs, lib, config, ... }:
let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in {
  imports = [
    ./hardware-configuration.nix
    # Includes the Home Manager module from the home-manager input in NixOS configuration
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations" # -> The hash is based on the output rather than the inputs.
      ];
      warn-dirty = false;
      flake-registry = ""; # Disable global flake registry
    };

    # Add each flake input as a registry and nix_path
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  networking.hostName = "plankton";

  users.users = {
    minimal = {
      initialPassword = "plankton";
      isNormalUser = true;
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ./ssh_host_ed25519_key.pub) ];
      extraGroups = [ "wheel" ];
    };
  };

  home-manager.users.minimal = import ../home.nix;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };
  system.stateVersion = "${config.system.nixos.release}";
}
