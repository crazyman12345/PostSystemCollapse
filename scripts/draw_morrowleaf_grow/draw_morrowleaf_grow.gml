function draw_morrowleaf_grow()
{
    terminal_header("MORROWLEAF CULTIVATION");

    // ==============================
    // NO ACTIVE GROW
    // ==============================

    if (!grow_active)
    {
        terminal_panel(
            80,
            180,
            1680,
            620,
            "GROW STATION"
        );

        terminal_value(
            120,
            270,
            "MORROWLEAF GROW KITS",
            inventory.morrowleaf_grow_kit,
            450
        );

        if (inventory.morrowleaf_grow_kit > 0)
        {
            draw_text(
                120,
                380,
                "A grow kit is available."
            );

            terminal_menu_item(
                120,
                480,
                "START MORROWLEAF GROW",
                true
            );

            terminal_prompt(
                "ENTER: START GROW    I: INVENTORY    ESC: BACK"
            );
        }
        else
        {
            draw_text(
                120,
                380,
                "[ NO MORROWLEAF GROW KIT AVAILABLE ]"
            );

            draw_text(
                120,
                440,
                "Craft a grow kit in the Drug Lab before starting cultivation."
            );

            terminal_prompt(
                "I: INVENTORY    ESC: BACK"
            );
        }

        return;
    }


    // ==============================
    // ACTIVE GROW
    // ==============================

    var remaining = max(0, grow.duration - grow.elapsed);

    var minutes = floor(remaining / 60);
    var seconds = floor(remaining mod 60);

    var seconds_text = string(seconds);

    if (seconds < 10)
    {
        seconds_text = "0" + seconds_text;
    }

    var time_text =
        string(minutes)
        + ":"
        + seconds_text;


    terminal_panel(
        80,
        180,
        780,
        620,
        "GROW STATUS"
    );

    terminal_value(
        120,
        250,
        "TIME REMAINING",
        time_text,
        350
    );

    terminal_value(
        120,
        310,
        "GROWTH",
        string(round(grow.growth)) + "%",
        350
    );

    terminal_value(
        120,
        370,
        "HEALTH",
        string(round(grow.health)) + "%",
        350
    );

    terminal_value(
        120,
        430,
        "QUALITY",
        string(round(grow.quality)) + "%",
        350
    );

	terminal_value(
	    120,
	    520,
	    "MOISTURE",
	    morrowleaf_get_moisture_status(),
	    350
	);

	terminal_value(
	    120,
	    580,
	    "NUTRIENTS",
	    morrowleaf_get_nutrient_status(),
	    350
	);

	terminal_value(
	    120,
	    640,
	    "STRESS",
	    morrowleaf_get_stress_status(),
	    350
	);


    terminal_panel(
        980,
        180,
        780,
        620,
        "ACTIONS"
    );

	 var water_text = "WATER";

	if (grow.water_cooldown > 0)
	{
	    water_text += " [" + string(ceil(grow.water_cooldown)) + "s]";
	}
	else
	{
	    water_text += " [READY]";
	}

	terminal_menu_item(
	    1040,
	    300,
	    water_text,
	    grow_menu_index == 0
	);

	var feed_text = "FEED";

	if (grow.feed_cooldown > 0)
	{
	    feed_text += " [" + string(ceil(grow.feed_cooldown)) + "s]";
	}
	else
	{
	    feed_text += " [READY]";
	}
	
	terminal_menu_item(
	    1040,
	    360,
	    feed_text,
	    grow_menu_index == 1
	);

	 var tend_text = "TEND";

	if (grow.tend_cooldown > 0)
	{
	    tend_text += " [" + string(ceil(grow.tend_cooldown)) + "s]";
	}
	else
	{
	    tend_text += " [READY]";
	}
	
	terminal_menu_item(
		1040,
		420,
		tend_text,
		grow_menu_index == 2
	);

    terminal_prompt(
        "W/S: SELECT    ENTER: PERFORM ACTION    I: INVENTORY    ESC: BACK"
    );
}