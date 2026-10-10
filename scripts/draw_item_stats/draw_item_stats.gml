function draw_item_stats(_item, _x, _y, _bottom)
{
    static _scroll = 0;
    static _scroll_dir = 1;
    static _pause_timer = 0;
    static _last_item_key = "";

    var _line_h = 26;
    var _lines = [];

    draw_set_font(fnt_terminal_small);
    draw_set_color(c_lime);


    // ==========================================
    // RESET SCROLL WHEN ITEM CHANGES
    // ==========================================

    if (_last_item_key != _item.item_key)
    {
        _last_item_key = _item.item_key;
        _scroll = 0;
        _scroll_dir = 1;
        _pause_timer = 60;
    }


    // ==========================================
    // BUILD STAT LIST
    // ==========================================

    switch (_item.category)
    {
        // ======================================
        // WEAPONS
        // ======================================

        case ItemCategory.WEAPON:

            if (variable_struct_exists(_item, "weight"))
                array_push(_lines,
                    "WEIGHT: " + string(_item.weight));

            if (variable_struct_exists(_item, "base_value"))
                array_push(_lines,
                    "VALUE: $" + string(_item.base_value));

            if (
                variable_struct_exists(_item, "damage_min")
                && variable_struct_exists(_item, "damage_max")
            )
            {
                array_push(_lines,
                    "DAMAGE: "
                    + string(_item.damage_min)
                    + " - "
                    + string(_item.damage_max)
                );
            }

            if (variable_struct_exists(_item, "fire_rate"))
                array_push(_lines,
                    "FIRE RATE: "
                    + string(_item.fire_rate)
                    + "/SEC");

            if (variable_struct_exists(_item, "mag_size"))
                array_push(_lines,
                    "MAGAZINE: "
                    + string(_item.mag_size));

            if (variable_struct_exists(_item, "reload_time"))
                array_push(_lines,
                    "RELOAD: "
                    + string(_item.reload_time)
                    + " FRAMES");

            if (variable_struct_exists(_item, "bullet_speed"))
                array_push(_lines,
                    "BULLET SPEED: "
                    + string(_item.bullet_speed));

            if (variable_struct_exists(_item, "accuracy_bonus"))
                array_push(_lines,
                    "ACCURACY: "
                    + string(_item.accuracy_bonus));

            if (variable_struct_exists(_item, "ammo_key"))
            {
                var _ammo = item_get(_item.ammo_key);

                if (is_struct(_ammo))
                {
                    array_push(_lines,
                        "AMMO: " + _ammo.name);
                }
            }

        break;


        // ======================================
        // BODY ARMOR
        // ======================================

        case ItemCategory.BODY_ARMOR:

            if (variable_struct_exists(_item, "weight"))
                array_push(_lines,
                    "WEIGHT: " + string(_item.weight));

            if (variable_struct_exists(_item, "base_value"))
                array_push(_lines,
                    "VALUE: $" + string(_item.base_value));

            if (variable_struct_exists(_item, "armor"))
                array_push(_lines,
                    "ARMOR: " + string(_item.armor));

        break;


        // ======================================
        // HEAD ARMOR
        // ======================================

        case ItemCategory.HEAD_ARMOR:

            if (variable_struct_exists(_item, "weight"))
                array_push(_lines,
                    "WEIGHT: " + string(_item.weight));

            if (variable_struct_exists(_item, "base_value"))
                array_push(_lines,
                    "VALUE: $" + string(_item.base_value));

            if (variable_struct_exists(_item, "armor"))
                array_push(_lines,
                    "ARMOR: " + string(_item.armor));

        break;


        // ======================================
        // BAGS
        // ======================================

        case ItemCategory.BAG:

            if (variable_struct_exists(_item, "weight"))
                array_push(_lines,
                    "WEIGHT: " + string(_item.weight));

            if (variable_struct_exists(_item, "base_value"))
                array_push(_lines,
                    "VALUE: $" + string(_item.base_value));

            if (variable_struct_exists(_item, "bag_capacity"))
                array_push(_lines,
                    "CAPACITY: "
                    + string(_item.bag_capacity));

        break;


        // ======================================
        // MEDICAL
        // ======================================

        case ItemCategory.MEDICAL:

            if (variable_struct_exists(_item, "weight"))
                array_push(_lines,
                    "WEIGHT: " + string(_item.weight));

            if (variable_struct_exists(_item, "base_value"))
                array_push(_lines,
                    "VALUE: $" + string(_item.base_value));

            if (variable_struct_exists(_item, "use_effects"))
            {
                for (
                    var i = 0;
                    i < array_length(_item.use_effects);
                    i++
                )
                {
                    var _effect =
                        _item.use_effects[i];

                    if (_effect.type == EffectType.HEAL)
                    {
                        array_push(_lines,
                            "HEAL: "
                            + string(_effect.amount));
                    }
                }
            }

        break;


        // ======================================
        // DEFAULT
        // ======================================

        default:

            if (variable_struct_exists(_item, "weight"))
                array_push(_lines,
                    "WEIGHT: " + string(_item.weight));

            if (variable_struct_exists(_item, "base_value"))
                array_push(_lines,
                    "VALUE: $" + string(_item.base_value));

        break;
    }


    // ==========================================
    // SCROLL CALCULATION
    // ==========================================

    var _visible_height =
        _bottom - _y;

    var _content_height =
        array_length(_lines)
        * _line_h;

    var _max_scroll =
        max(
            0,
            _content_height
            - _visible_height
        );


    // ==========================================
    // AUTOMATIC SCROLL
    // ==========================================

    if (_max_scroll > 0)
    {
        if (_pause_timer > 0)
        {
            _pause_timer -= frame_scale;
        }
        else
        {
            _scroll +=
                0.30
                * frame_scale
                * _scroll_dir;


            // REACHED BOTTOM
            if (_scroll >= _max_scroll)
            {
                _scroll = _max_scroll;
                _scroll_dir = -1;
                _pause_timer = 90;
            }


            // REACHED TOP
            if (_scroll <= 0)
            {
                _scroll = 0;
                _scroll_dir = 1;
                _pause_timer = 90;
            }
        }
    }
    else
    {
        _scroll = 0;
    }


    // ==========================================
    // DRAW ONLY INSIDE STAT BOX
    // ==========================================

    for (
        var i = 0;
        i < array_length(_lines);
        i++
    )
    {
        var _draw_y =
            _y
            + (i * _line_h)
            - _scroll;


        // Don't draw above or below stat panel
        if (
            _draw_y >= _y
            && _draw_y <= _bottom - _line_h
        )
        {
            draw_text(
                _x,
                _draw_y,
                _lines[i]
            );
        }
    }
}
