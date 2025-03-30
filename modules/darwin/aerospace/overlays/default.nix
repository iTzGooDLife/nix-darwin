{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
      (self: super: {
        aerospace = super.aerospace.override {
          configPath = "${config.home.homeDirectory}/.config/aerospace/aerospace.toml";
        };
      })
    ];
}
