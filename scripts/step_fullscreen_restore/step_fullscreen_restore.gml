function step_fullscreen_restore(){
if (fullscreen_restore_steps >= 0) {
    fullscreen_restore_steps += 1;
    if (fullscreen_restore_steps >= 10) {
        window_enable_borderless_fullscreen(windowed_borderless_fullscreen);
        window_set_showborder(windowed_showborder);
        window_set_rectangle(windowed_x, windowed_y, windowed_width, windowed_height);
        fullscreen_restore_steps = -1;
    }
}
}