function draw_hideout()
{
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var sidebar_w = 320;
    var margin = 25;

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_lime);

    // SIDEBAR
    draw_rectangle(1, 1, sidebar_w, gui_h, true);
    draw_line(sidebar_w, 0, sidebar_w, gui_h);

    draw_text(margin, 25, "HIDEOUT");

    var _y = 85;

    for (var i = 0; i < array_length(hideout_menu_items); i++)
    {
        var entry = hideout_menu_items[i];

        // SECTION HEADING
        if (entry.header != "")
        {
            _y += 18;
            draw_text_transformed(margin, _y, entry.header, 0.75, 0.75, 0);
            _y += 32;
        }

        // CURSOR
        var cursor = "  ";
        if (i == hideout_menu_index) cursor = "> ";

        // MENU ITEM
        draw_set_halign(fa_left);
        if (entry.bench_key != "" && variable_struct_get(workshop_progress, entry.bench_key) <= 0)
            draw_set_color(c_gray);
        else
            draw_set_color(c_lime);
        draw_text(margin, _y, cursor + entry.name);

        // SKILL LEVEL
        if (entry.skill_key != "")
        {
            var level = skill_get_level(entry.skill_key);

            draw_set_halign(fa_right);
            draw_text(sidebar_w - 25, _y, string(level) + "/100");
            draw_set_halign(fa_left);
        }

        _y += 34;

        // SPACING AFTER STASH
        if (entry.key == "workshop") _y += 30;

        // SPACING BEFORE RAIDS / WORKSHOP
        if (entry.key == "drugmaking") _y += 30;
    }

    // CONTENT AREA
	var content_x1 = sidebar_w;
	var content_y1 = 1;
	var content_x2 = gui_w;
	var content_y2 = gui_h;

    draw_rectangle(content_x1, content_y1, content_x2, content_y2, true);

    var selected = hideout_menu_items[hideout_menu_index];

    draw_set_halign(fa_left);
    draw_text(content_x1 + 25, content_y1 + 20, selected.name);
    draw_line(content_x1 + 20, content_y1 + 60, content_x2 - 20, content_y1 + 60);

    // RIGHT SIDE CONTENT
    if (selected.bench_key != "" && variable_struct_get(workshop_progress, selected.bench_key) <= 0)
    {
        var bench = variable_struct_get(workshop_db, selected.bench_key);
        draw_text(content_x1 + 25, content_y1 + 75, "[LOCKED]");
        draw_text(content_x1 + 25, content_y1 + 125, "BUILD THE " + bench.name + " IN THE WORKSHOP TO UNLOCK.");
    }
    else switch (selected.key)
    {
        case "traders":
            draw_hideout_traders();
        break;

        case "stash":
            draw_hideout_stash();
        break;

        case "skills":
            draw_hideout_skills();
        break;
		
		case "workshop":
            draw_workshop();
        break;
		
		case "salvaging":
			draw_hideout_salvage();
		break;
		
        case "gunmaking":
        case "armorcrafting":
        case "drugmaking":
        case "medical_crafting":
            draw_hideout_crafting(selected.key, content_x1, content_y1, content_x2, content_y2);
        break;

        case "raids":
            draw_hideout_raid_select();
        break;

     
    }

    draw_set_halign(fa_left);
    draw_set_color(c_white);
}
