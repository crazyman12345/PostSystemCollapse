function raid_generate_room_wall_lights()
{
    raid_wall_lights = [];
    raid_light_sources = [];
    raid_shadow_occluders = [];
    var _warm_orange = make_color_rgb(255, 150, 55);
	var buf = 6;
    //right
    raid_spawn_wall_light(1168 - buf, 457, 180, true, 125, _warm_orange, 0.42, 64, true);
    raid_spawn_wall_light(1168 - buf, 620, 180, true, 125, _warm_orange, 0.42, 64, true);
    //left
    raid_spawn_wall_light(752 + buf, 620, 0, true, 125, _warm_orange, 0.42, 64, true);
    raid_spawn_wall_light(752 + buf, 457, 0, true, 125, _warm_orange, 0.42, 64, true);
    //top
    raid_spawn_wall_light(1101, 335 + buf, 270, true, 125, _warm_orange, 0.42, 64, true);
    raid_spawn_wall_light(819, 335 + buf, 270, true, 125, _warm_orange, 0.42, 64, true);

    //bottom
    raid_spawn_wall_light(1101, 745 - buf, 90, true, 125, _warm_orange, 0.42, 64, true);
    raid_spawn_wall_light(819, 745 - buf, 90, true, 125, _warm_orange, 0.42, 64, true);
}
