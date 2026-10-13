function toggle_fullscreen(){
  if (fullscreen_active) {
        window_set_fullscreen(false);
        fullscreen_restore_steps = 0;
        fullscreen_active = false;
    } else if (fullscreen_restore_steps < 0) {
        windowed_x = window_get_x();
        windowed_y = window_get_y();
        windowed_width = window_get_width();
        windowed_height = window_get_height();
        windowed_showborder = window_get_showborder();
        windowed_borderless_fullscreen = window_get_borderless_fullscreen();

        var _display_rects = window_get_visible_rects(
            windowed_x,
            windowed_y,
            windowed_x + windowed_width,
            windowed_y + windowed_height
        );
        var _target_display = 0;
        var _largest_overlap = -1;

        for (var _display = 0; _display < array_length(_display_rects); _display += 8) {
            var _overlap_width = max(0, _display_rects[_display + 2] - _display_rects[_display]);
            var _overlap_height = max(0, _display_rects[_display + 3] - _display_rects[_display + 1]);
            var _overlap_area = _overlap_width * _overlap_height;

            if (_overlap_area > _largest_overlap) {
                _largest_overlap = _overlap_area;
                _target_display = _display;
            }
        }

        var _display_x = _display_rects[_target_display + 4];
        var _display_y = _display_rects[_target_display + 5];
        var _display_width = _display_rects[_target_display + 6] - _display_x;
        var _display_height = _display_rects[_target_display + 7] - _display_y;
        var _target_is_primary = (_display_x == 0 && _display_y == 0);

        window_set_fullscreen(false);
        window_enable_borderless_fullscreen(!_target_is_primary);
        window_set_rectangle(_display_x, _display_y, _display_width, _display_height);
        window_set_fullscreen(true);
        fullscreen_active = true;
    }
}