{ inputs, config, pkgs, lib, ... }:

let name = "Julio";
    user = "jcerda";
    email = "jcerda@fluidattacks.com"; in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "softmoth/zsh-vim-mode"; }
      ];
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];

    initExtraFirst = ''
      source ~/.zshrc_secrets
      export PATH=$PATH:/Users/${user}/Library/Android/sdk/platform-tools/


      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=/opt/homebrew/bin/:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      export ALTERNATE_EDITOR=""
      export EDITOR="nvim"
      export VISUAL="code"

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      # Always color ls and group directories
      alias ls='ls --color=auto'
      alias ll='ls -lah --color=auto'
      alias repo-clone='m github:fluidattacks/universe@trunk /melts pull-repos --group'
      alias push-repos='m github:fluidattacks/universe@trunk /melts push-repos --group'
      alias signals='nix run "github:fluidattacks/universe?dir=signals"'


      #### Own aliases ####
      alias tree="tree -C"
      alias watch="watch -n 1"
      alias grep='grep --color=auto'

      ## Git
      alias ga='git add'
      alias gc='git commit -v'
      alias gd='git diff'
      alias gst='git status'

      alias gco='git checkout'
      alias gcm='git checkout master'

      alias gb='git branch'


      # view remote branches
      alias gbr='git branch --remote'

      alias gup='git pull --rebase'
      alias gp='git push'
      alias gl='git pull'
      alias gr='git restore'

      # push a newly created local branch to origin
      alias gpsup='git push --set-upstream origin $(git_current_branch)'
      #### Own aliases ####


      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
	    editor = "nvim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Block";
      };

      window = {
        opacity = 0.9;
        padding = {
          x = 15;
          y = 15;
        };
      };

      font = {
        normal = {
          # family = "MesloLGS NF";
          # style = "Regular";
          family = "JetBrainsMonoNL Nerd Font";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
        ];
      };

      # dynamic_padding = true;
      # decorations = "full";
      # title = "Terminal";
      # class = {
      #   instance = "Alacritty";
      #   general = "Alacritty";
      # };

      colors = {
        primary = {
          # background = "0x1f2528";
          # foreground = "0xc0c5ce";
          background = "#1f1d29";
          foreground = "#eaeaea";
        };

        normal = {
          # black = "0x1f2528";
          # red = "0xec5f67";
          # green = "0x99c794";
          # yellow = "0xfac863";
          # blue = "0x6699cc";
          # magenta = "0xc594c5";
          # cyan = "0x5fb3b3";
          # white = "0xc0c5ce";
          black = "#6f6e85";
          red = "#ea6f91";
          green = "#9bced7";
          yellow = "#f1ca93";
          blue = "#34738e";
          magenta = "#c3a5e6";
          cyan = "#eabbb9";
          white = "#faebd7";
        };

        bright = {
          # black = "0x65737e";
          # red = "0xec5f67";
          # green = "0x99c794";
          # yellow = "0xfac863";
          # blue = "0x6699cc";
          # magenta = "0xc594c5";
          # cyan = "0x5fb3b3";
          # white = "0xd8dee9";
          black = "#6f6e85";
          red = "#ea6f91";
          green = "#9bced7";
          yellow = "#f1ca93";
          blue = "#34738e";
          magenta = "#c3a5e6";
          cyan = "#ebbcba";
          white = "#e0def4";
        };
      };
    };
  };

  ssh = {
    enable = true;
    includes = [
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        "/home/${user}/.ssh/config_external"
      )
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        "/Users/${user}/.ssh/config_external"
      )
    ];
    matchBlocks = {
      "github.com" = {
        identitiesOnly = true;
        identityFile = [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
            "/home/${user}/.ssh/id_github"
          )
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
            "/Users/${user}/.ssh/id_github"
          )
        ];
      };
    };
  };

  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      prefix-highlight
      {
        plugin = power-theme;
        extraConfig = ''
           set -g @tmux_power_theme 'gold'
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    terminal = "screen-256color";
    prefix = "C-b";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      # Remove Vim mode delays
      set -g focus-events on

      # Enable full mouse support
      set -g mouse on

      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

      # Unbind default keys

      # Split panes, vertical or horizontal
      bind-key - split-window -v
      bind-key _ split-window -h

      # Move around panes with vim-like bindings (h,j,k,l)
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-l select-pane -R

      # Smart pane switching with awareness of Vim splits.
      # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
      set-option -g default-shell /bin/zsh
      set-option -g default-command "zsh"
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi V send -X select-line
      set -s copy-command 'pbcopy'
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'pbcopy'
      '';
    };
}
