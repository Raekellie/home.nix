{...}: {
  programs = {
    mangohud = {
      enable = true;
      enableSessionWide = true;

      settings = {
        fps_limit = 120;
        fps = 1;
        frame_timing = 0;
        cpu_stats = true;
        cpu_temp = 1;
        gpu_stats = 1;
        gpu_temp = 1;
        ram = 1;
        vram = 1;

        no_display = true;
        toggle_hud = "Shift_R+F11";
        toggle_hud_position = "Shift_R+F10";
        toggle_preset = "";
        reset_fps_metrics = "";
      };
    };
  };
}
