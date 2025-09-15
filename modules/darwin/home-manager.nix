{ inputs, config, pkgs, lib, home-manager, ... }:

let
  user = "jcerda";
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
   inputs.home-manager.darwinModules.home-manager
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    # onActivation.cleanup = "uninstall";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
  };

  # Enable home-manager
home-manager = {
  useGlobalPkgs = true;
  extraSpecialArgs = { inherit inputs; };
  users.${user} = { pkgs, config, lib, inputs, system, ... }: {
    home = {
      enableNixpkgsReleaseCheck = false;
      packages = pkgs.callPackage ./packages.nix { inherit inputs; };
      file = lib.mkMerge [
        sharedFiles
        additionalFiles
      ];
      stateVersion = "23.11";
    };

    programs = {} // import ../shared/home-manager.nix { inherit inputs config pkgs lib; };
    manual.manpages.enable = false;
  };
};

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/System/Applications/Firefox.app/"; }
    { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
    { path = "/System/Applications/Launchpad.app/"; }
    { path = "/System/Applications/System Settings.app/"; }
    {
      path = "${config.users.users.${user}.home}/.local/share/";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
    {
      path = "${config.users.users.${user}.home}/.local/share/downloads";
      section = "others";
      options = "--sort name --view grid --display stack";
    }
  ];

}
