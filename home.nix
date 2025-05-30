{
  home = {
    username = "minimal";
    homeDirectory = "/home/minimal";
    stateVersion = "25.11";
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  systemd.user.startServices = "sd-switch";
}
