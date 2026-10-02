function draw_raid_combat_item_select()
{
    var gui_w =
        display_get_gui_width();

    var gui_h =
        display_get_gui_height();


    // ------------------------------------------
    // PANEL
    // ------------------------------------------

    var panel_w = 520;
    var panel_h = 620;

    var x1 =
        (gui_w - panel_w) / 2;

    var y1 =
        (gui_h - panel_h) / 2;

    var x2 =
        x1 + panel_w;

    var y2 =
        y1 + panel_h;
		
	draw_set_color(c_black);
	draw_rectangle(x1,y1,x2,y2,false);
	draw_set_color(c_lime);

    draw_set_font(
        fnt_terminal_small
    );
    draw_ascii_rectangle(
        x1,
        y1,
        x2,
        y2
    );


    // ------------------------------------------
    // TITLE
    // ------------------------------------------

    draw_text(
        x1 + 30,
        y1 + 25,
        "USE ITEM"
    );


    draw_text(
        x1 + 30,
        y1 + 55,
        "-----------------------"
    );


    // ------------------------------------------
    // GET USABLE ITEMS
    // ------------------------------------------

    var items = raid_combat_get_usable_items();


    // No usable items
    if (array_length(items) <= 0)
    {
        draw_text(
            x1 + 35,
            y1 + 110,
            "NO USABLE ITEMS"
        );


        draw_text(
            x1 + 30,
            y2 - 85,
            "------------------"
        );


        draw_text(
            x1 + 35,
            y2 - 50,
            "[ESC] BACK"
        );

        return;
    }


    // Keep index valid
    raid.combat_item_index =
        clamp(
            raid.combat_item_index,
            0,
            array_length(items) - 1
        );


    // ------------------------------------------
    // ITEM LIST
    // ------------------------------------------

    var list_y =
        y1 + 100;

    var row_h = 38;


    for (
        var i = 0;
        i < array_length(items);
        i++
    )
    {
        var item_key =
            items[i];

        var item =
            item_get(item_key);

        var quantity =
            raid_bag_get_quantity(
                item_key
            );


        var prefix = "  ";

        if (
            i
            == raid.combat_item_index
        )
        {
            prefix = "> ";
        }


        draw_text(
            x1 + 35,
            list_y,
            prefix
            + item.name
        );


        draw_text(
            x2 - 100,
            list_y,
            "x"
            + string(quantity)
        );


        list_y += row_h;
    }


    // ------------------------------------------
    // SELECTED ITEM
    // ------------------------------------------

    var selected_key =
        items[
            raid.combat_item_index
        ];

    var selected_item =
        item_get(
            selected_key
        );


    var info_y =
        y1 + 330;


    draw_text(
        x1 + 30,
        info_y,
        "-----------------------"
    );


    draw_text(
        x1 + 35,
        info_y + 45,
        selected_item.name
    );


    // ------------------------------------------
    // DESCRIPTION
    // ------------------------------------------

    if (
        variable_struct_exists(
            selected_item,
            "description"
        )
    )
    {
        draw_text_ext(
            x1 + 35,
            info_y + 90,
            selected_item.description,
            28,
            panel_w - 70
        );
    }


    // ------------------------------------------
    // USE EFFECT
    // ------------------------------------------

    if (
        variable_struct_exists(
            selected_item,
            "use_effects"
        )
        && array_length(
            selected_item.use_effects
        ) > 0
    )
    {
        var effect =
            selected_item.use_effects[0];


        if (
            variable_struct_exists(
                effect,
                "amount"
            )
        )
        {
            draw_text(
                x1 + 35,
                info_y + 180,
                "EFFECT: "
                + string(effect.amount)
            );
        }
    }


    // ------------------------------------------
    // CONTROLS
    // ------------------------------------------

    draw_text(
        x1 + 30,
        y2 - 85,
        "-------------------------"
    );


    draw_text(
        x1 + 35,
        y2 - 50,
        "[W/S] SELECT"
    );


    draw_text(
        x1 + 290,
        y2 - 50,
        "[ENTER] USE"
    );


}