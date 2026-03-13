{config, ...}: {
  colorschemes = {
    catppuccin = {
      enable = false;
      settings = {
        flavor = "mocha";
        italic = true;
        bold = true;
        dimInactive = false;
        transparent_background = true;
      };
    };
    oxocarbon = {
      enable = false;
    };
    monokai-pro = {
      enable = false;
      settings = {
        transparent_background = true;
      };
    };
    nightfox = {
      enable = false;
      flavor = "carbonfox";
      settings = {
        transparent = true;
        styles = {
          comments = "italic";
          keywords = "bold,italic";
          functions = "italic";
          variables = "none";
          sidebars = "dark";
          floats = "dark";
        };
      };
    };
    base16 = {
      enable = false;
      colorscheme = "tomorrow-night"; # fallback; overridden by Stylix via .extend()
    };
    vague = {
      enable = false;
      settings = {
        transparent = true;
        styles = {
          comments = "italic";
          keywords = "bold,italic";
          functions = "italic";
          variables = "none";
          sidebars = "dark";
          floats = "dark";
        };
      };
    };
    kanagawa = {
      enable = true;
      settings = {
        transparent = true;
        styles = {
          comments = "italic";
          keywords = "bold,italic";
          functions = "italic";
          variables = "none";
          sidebars = "dark";
          floats = "dark";
        };
      };
    };
    github-theme = {
      enable = false;
      settings = {
        theme_style = "dark_default";
        transparent = false;
        styles = {
          comments = "italic";
          keywords = "bold,italic";
          functions = "italic";
          variables = "none";
          sidebars = "dark";
          floats = "dark";
        };
      };
    };
    tokyonight = {
      enable = false;
      settings = {
        style = "night";
        transparent = true;
        styles = {
          floats = "dark";
          sidebars = "dark";
          comments.italic = true;
          functions.italic = true;
          variables.italic = true;
          keywords = {
            italic = true;
            bold = true;
          };
        };
      };
    };
  };
}
