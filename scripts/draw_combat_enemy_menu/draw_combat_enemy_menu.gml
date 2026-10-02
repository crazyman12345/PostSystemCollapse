function draw_combat_enemy_menu()
{
    var area = combat_area_db[combat_area_index];

    var panel_left = 560;
    var panel_top = 160;
    var panel_width = 1120;
    var panel_height = 760;
	draw_set_color(c_black);
	draw_rectangle(panel_left, panel_top, panel_left + panel_width, panel_height + panel_top, false);
	draw_set_color(c_lime);
    terminal_panel(panel_left, panel_top, panel_width, panel_height, area.name + " // ENEMIES");

    var _y = panel_top + 80;

    for (var i = 0; i < array_length(area.enemies); i++)
    {
        var enemy_key = area.enemies[i];
        var enemy = enemy_get(enemy_key);

        var selected = (i == combat_enemy_index);

        var image_left = panel_left + 50;
        var image_top = _y;
        var image_size = 80;

        terminal_box(image_left, image_top, image_size, image_size);

        if (enemy.sprite != -1)
            draw_sprite_stretched(enemy.sprite, 0, image_left + 3, image_top + 3, image_size - 6, image_size - 6);
        else
        {
            draw_set_halign(fa_center);
            draw_text(image_left + (image_size / 2), image_top + 28, "-1");
            draw_set_halign(fa_left);
        }

        var cursor = "  ";
        if (selected) cursor = "> ";

        draw_text(panel_left + 160, _y + 10, cursor + enemy.name);
        draw_text(panel_left + 650, _y + 10, "LV. " + string(enemy.level));
        draw_text(panel_left + 820, _y + 10, "HP " + string(enemy.max_hp));

        _y += 100;
    }

    draw_text(panel_left + 50, panel_top + panel_height - 55, "[W/S] SELECT    [ENTER] ENGAGE    [ESC] BACK");
}