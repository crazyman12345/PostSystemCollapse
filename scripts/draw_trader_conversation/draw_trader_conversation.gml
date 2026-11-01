function draw_trader_conversation()
{
    if (is_undefined(dialogue_current_node)) return;
    var trader = trader_get(current_trader_key);
    var left = 345;
    var top = 85;
    var right = display_get_gui_width() - 35;
    var bottom = display_get_gui_height() - 25;
    var divider = 950;

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(global.hideout_panel_color);
    draw_rectangle(left, top, right, bottom, false);
    heading_box(left, top, right - left, bottom - top, "MESSAGES // " + string_upper(trader.name));
    draw_set_color(global.hideout_border_subtle_color);
    draw_line(divider, top + 92, divider, bottom - 25);

    draw_set_font(fnt_terminal_tiny);
    var portrait_left = left + 28;
    var portrait_top = top + 100;
    var portrait_width = 280;
    var portrait_height = 330;
    draw_set_color(global.ui_text_color);
    if (trader.portrait != -1)
    {
        draw_chamfered_sprite(trader.portrait, 0, portrait_left + 3, portrait_top + 3,
            portrait_width - 6, portrait_height - 6, 9, merge_color(c_white, global.hideout_secondary_color, 0.5), 1);
    }
    else
    {
        draw_set_halign(fa_center);
        draw_set_color(global.ui_text_color);
        draw_text(portrait_left + portrait_width / 2, portrait_top + portrait_height / 2, "[ NO IMAGE ]");
        draw_set_halign(fa_left);
    }
    draw_set_color(global.ui_text_color);
    terminal_box(portrait_left, portrait_top, portrait_width, portrait_height);

    draw_set_color(global.ui_text_color);
    draw_text_ext(portrait_left + portrait_width + 28, portrait_top + 25, trader.description, 23,
        divider - portrait_left - portrait_width - 56);

    draw_text(left + 28, top + 455, "RECENT MESSAGES");
    var history_y = top + 500;
    var history_end = max(0, array_length(dialogue_history) - 1);
    var first_history = max(0, history_end - 6);
    for (var i = first_history; i < history_end; i++)
    {
        var entry = dialogue_history[i];
        draw_set_color(entry.speaker == "YOU" ? global.ui_text_color : global.ui_text_color);
        draw_text(left + 32, history_y, string_upper(entry.speaker) + ":");
        history_y += 28;
        draw_text_ext(left + 48, history_y, entry.message, 23, divider - left - 85);
        history_y += string_height_ext(entry.message, 23, divider - left - 85) + 24;
        if (history_y > bottom - 65) break;
    }

    draw_set_font(fnt_terminal_medium);
    draw_set_color(global.ui_text_color);
    draw_text(divider + 55, top + 105, string_upper(dialogue_current_node.speaker));
    draw_set_font(fnt_terminal_small);
    draw_set_color(global.ui_text_color);
    draw_text_ext(divider + 55, top + 165, dialogue_current_node.message, 29, right - divider - 105);
    draw_line(divider + 45, top + 445, right - 45, top + 445);

    var responses = dialogue_get_visible_responses(dialogue_current_node);
    var row_height = 58;
    var visible_rows = 7;
    var response_y = 555;
    for (var row = 0; row < visible_rows; row++)
    {
        var index = dialogue_response_scroll + row;
        if (index >= array_length(responses)) break;
        var selected = index == dialogue_response_index;
        var row_top = response_y + row * row_height - 5;
        var row_bottom = response_y + row * row_height + 43;
        terminal_button(1010, row_top, right - 48, row_bottom,
            string(index + 1) + ". " + responses[index].text, selected);
        if (string_pos("claim:", responses[index].target) == 1)
        {
            draw_set_halign(fa_right);
            draw_set_color(c_red);
            draw_text(right - 65, response_y + row * row_height, "?");
            draw_set_halign(fa_left);
        }
        else if (string_pos("available:", responses[index].target) == 1
        && dialogue_trader_has_available_quest(current_trader_key))
        {
            draw_set_halign(fa_right);
            draw_set_color(c_red);
            draw_text(right - 65, response_y + row * row_height, "!");
            draw_set_halign(fa_left);
        }
    }
}

function draw_messages_all()
{
    var trader_keys = onboarding_is_active() ? ["ghost"] : trader_get_message_keys();
    var left = 320;
    var top = 1;
    var right = display_get_gui_width();
    var bottom = display_get_gui_height();
    var divider = 950;

    menu_index = clamp(menu_index, 0, array_length(trader_keys) - 1);
    var selected_trader = trader_get(trader_keys[menu_index]);
    var root_id = onboarding_is_active() ? onboarding_mara_node_id()
        : variable_struct_get(global.dialogue_roots, trader_keys[menu_index]);
    var preview_node = dialogue_resolve_node(root_id);

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(global.hideout_panel_color);
    draw_rectangle(left, top, right, bottom, false);
    heading_box(left, top, right - left, bottom - top, "MESSAGES // ALL");
    draw_set_color(global.ui_text_color);
    draw_line(divider, top + 92, divider, bottom - 25);

    draw_set_font(fnt_terminal_tiny);
    draw_text(left + 28, top + 100, "RECENT MESSAGES: ALL");
    for (var i = 0; i < array_length(trader_keys); i++)
    {
        var trader = trader_get(trader_keys[i]);
        var row_top = top + 150 + i * 92;
        var selected = i == menu_index;
        if (selected)
        {
            draw_set_color(global.hideout_raised_color);
            draw_rectangle(left + 25, row_top - 8, divider - 25, row_top + 68, false);
        }
        draw_set_color(global.ui_interactive_color);
        draw_text(left + 38, row_top, string_upper(trader.name));
        if (dialogue_trader_has_ready_quest(trader_keys[i]))
        {
            draw_set_halign(fa_right);
            draw_set_color(c_red);
            draw_text(divider - 48, row_top, "?");
            draw_set_halign(fa_left);
        }
        draw_set_color(global.ui_text_color);
        draw_text(left + 58, row_top + 36, trader.title);
    }

    draw_set_font(fnt_terminal_medium);
    draw_set_color(global.ui_text_color);
    draw_text(divider + 55, top + 105, string_upper(selected_trader.name));
    draw_set_font(fnt_terminal_tiny);
    draw_set_color(global.ui_text_color);
    draw_text(divider + 55, top + 155, string_upper(selected_trader.title));
    draw_line(divider + 45, top + 205, right - 45, top + 205);
    draw_text(divider + 55, top + 240, "LATEST MESSAGE");
    draw_set_font(fnt_terminal_small);
    draw_text_ext(divider + 55, top + 295, preview_node.message, 29, right - divider - 105);
}
