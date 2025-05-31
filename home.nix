{
  home = {
    username = "minimal";
    homeDirectory = "/home/minimal";
    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  systemd.user.startServices = "sd-switch";

}
