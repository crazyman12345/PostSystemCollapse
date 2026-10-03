function draw_raid_health_ui()
{
    var _x = 30;
    var _y = 30;

    var _hp_w = 180;
    var _bar_h = 18;
    var _stamina_y = _y + _bar_h + 4;
    var _stamina_h = 10;

    var _armor_per_hit = 10;

    var _armor_segment_w =
        _hp_w
        / (
            raid_player_max_hp
            / 10
        );


    // ==============================
    // HEALTH BACKGROUND
    // ==============================

    draw_set_color(
        make_color_rgb(
            40,
            40,
            40
        )
    );

    draw_rectangle(
        _x,
        _y,
        _x + _hp_w,
        _y + _bar_h,
        false
    );


    // ==============================
    // HEALTH
    // ==============================

    var _hp_percent =
        raid_player_hp
        / raid_player_max_hp;

    draw_set_color(c_red);

    draw_rectangle(
        _x,
        _y,
        _x
        + (_hp_w * _hp_percent),
        _y + _bar_h,
        false
    );


    // ==============================
    // ARMOR
    // ==============================

    if (raid_player_armor > 0)
    {
        var _armor_w =
            (
                raid_player_armor
                / _armor_per_hit
            )
            * _armor_segment_w;

        draw_set_color(c_blue);

        draw_rectangle(
            _x + _hp_w,
            _y,
            _x + _hp_w + _armor_w,
            _y + _bar_h,
            false
        );
    }


    // ==============================
    // OUTLINE
    // ==============================

    draw_set_color(c_white);

    draw_rectangle(
        _x,
        _y,
        _x + _hp_w,
        _y + _bar_h,
        true
    );


    // ==============================
    // STAMINA
    // ==============================

    var _stamina_percent =
        raid_player_stamina
        / raid_player_max_stamina;

    draw_set_color(
        make_color_rgb(
            40,
            40,
            40
        )
    );

    draw_rectangle(
        _x,
        _stamina_y,
        _x + _hp_w,
        _stamina_y + _stamina_h,
        false
    );

    draw_set_color(c_green);

    draw_rectangle(
        _x,
        _stamina_y,
        _x + (_hp_w * _stamina_percent),
        _stamina_y + _stamina_h,
        false
    );

    draw_set_color(c_white);

    draw_rectangle(
        _x,
        _stamina_y,
        _x + _hp_w,
        _stamina_y + _stamina_h,
        true
    );


    // ==============================
    // TEXT
    // ==============================

    draw_set_font(
        fnt_terminal_small
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        _x + (_hp_w * 0.5),
        _y + (_bar_h * 0.5),
        string(raid_player_hp)
        + " HP"
    );
}
