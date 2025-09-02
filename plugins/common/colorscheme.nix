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
      enable = true;
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
