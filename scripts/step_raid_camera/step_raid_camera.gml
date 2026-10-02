function step_raid_camera()
{
    var _cam_w = camera_get_view_width(raid_camera);
    var _cam_h = camera_get_view_height(raid_camera);

    var _cam_x = raid_player_x - (_cam_w * 0.5);
    var _cam_y = raid_player_y - (_cam_h * 0.5);

    _cam_x = round(_cam_x);
    _cam_y = round(_cam_y);

    camera_set_view_pos(
        raid_camera,
        _cam_x,
        _cam_y
    );
}