{ inputs, config, pkgs, lib, ... }:

let user = "cvera"; in

{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
  ];

  nix = {
    package = pkgs.nix;
    enable = false;

    settings = {
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };


    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.checks.verifyNixPath = false;

  environment.systemPackages = with pkgs; [
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  # security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.text = ''
      auth       optional       ${lib.getLib pkgs.pam-reattach}/lib/pam/pam_reattach.so
      auth       sufficient     pam_tid.so
    '';

  system = {
    stateVersion = 5;
    primaryUser = "cvera";
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        KeyRepeat = 2; # Values: 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # Values: 120, 94, 68, 35, 25, 15

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 40;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
 services.aerospace = {
    enable = true;
    
    settings = {
      after-startup-command = ["exec-and-forget sketchybar"];

      exec-on-workspace-change = [
        "/bin/bash" 
        "-c" 
        ''sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE''
        "exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0"
      ];

      start-at-login = false;
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 300;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      automatically-unhide-macos-hidden-apps = false;

      "key-mapping".preset = "qwerty";

      gaps = {
        inner.horizontal = 20;
        inner.vertical = 20;
        outer.left = 20;
        outer.bottom = 10;
        outer.top = 10;
        outer.right = 20;
      };

      mode.main.binding = {
        "alt-f" = "fullscreen";
        "alt-ctrl-f" = "layout floating tiling";
        "alt-shift-left" = "join-with left";
        "alt-shift-down" = "join-with down";
        "alt-shift-up" = "join-with up";
        "alt-shift-right" = "join-with right";
        "alt-slash" = "layout tiles horizontal vertical";
        "alt-comma" = "layout accordion horizontal vertical";
        "alt-h" = "focus left";
        "alt-j" = "focus down";
        "alt-k" = "focus up";
        "alt-l" = "focus right";
        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";
        "alt-shift-minus" = "resize smart -50";
        "alt-shift-equal" = "resize smart +50";
        "alt-1" = "workspace 1";
        "alt-2" = "workspace 2";
        "alt-3" = "workspace 3";
        "alt-4" = "workspace 4";
        "alt-shift-1" = "move-node-to-workspace 1 --focus-follows-window";
        "alt-shift-2" = "move-node-to-workspace 2 --focus-follows-window";
        "alt-shift-3" = "move-node-to-workspace 3 --focus-follows-window";
        "alt-shift-4" = "move-node-to-workspace 4 --focus-follows-window";
        "alt-tab" = "workspace-back-and-forth";
        "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";
        "alt-shift-comma" = "mode service";
        "alt-shift-enter" = "mode apps";
        "alt-enter" = "exec-and-forget open -a '/Applications/Nix Apps/Alacritty.app'";
      };

      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"];
        f = ["layout floating tiling" "mode main"];
        backspace = ["close-all-windows-but-current" "mode main"];
      };

      mode.apps.binding = {
        "alt-w" = ["exec-and-forget open -a /Applications/WezTerm.app" "mode main"];
      };

      # Uncomment if needed:
      # workspace-to-monitor-force-assignment = {
      #   "1" = "^dell$";
      #   "2" = "^dell$";
      #   "3" = "^dell$";
      #   "4" = "^dell$";
      #   "5" = "main";
      #   "6" = "^elgato$";
      # };
    };
  };
}
