{...}: {
  opts.guifont = "MesloLGM Nerd Font Mono:h10";

  globals = {
    neovide_opacity = 0.8;

    # Cursor
    neovide_cursor_animation_length = 0.1;
    neovide_cursor_trail_size = 0.8;
    neovide_cursor_antialiasing = true;
    neovide_cursor_vfx_mode = "railgun";
    neovide_cursor_vfx_opacity = 200.0;
    neovide_cursor_vfx_particle_lifetime = 1.2;
    neovide_cursor_vfx_particle_density = 7.0;
    neovide_cursor_vfx_particle_speed = 10.0;

    # Scroll
    neovide_scroll_animation_length = 0.3;
    neovide_scroll_animation_far_lines = 9999;

    neovide_hide_mouse_when_typing = true;

    # Padding
    neovide_padding_top = 8;
    neovide_padding_bottom = 8;
    neovide_padding_left = 8;
    neovide_padding_right = 8;

    # Floating windows
    neovide_floating_blur_amount_x = 2.0;
    neovide_floating_blur_amount_y = 2.0;
    neovide_floating_shadow = true;

    # Window
    neovide_remember_window_size = true;
    neovide_confirm_quit = true;
  };
}
