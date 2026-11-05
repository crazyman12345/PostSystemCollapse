function draw_quest_contract_reward_item(_reward, _left, _top, _size, _amber)
{
    draw_set_color(make_color_rgb(18, 20, 14));
    draw_item_info_chamfer_fill(_left, _top, _left + _size, _top + _size, 8);
    draw_set_color(_amber);
    draw_border_frame2_path(_left, _top, _left + _size, _top + _size, 8);
    draw_set_alpha(0.35);
    draw_border_frame2_path(_left + 3, _top + 3, _left + _size - 3, _top + _size - 3, 5);
    draw_set_alpha(1);

    var definition = item_get(_reward.item_key);
    if (is_undefined(definition)) return;
    var reward_sprite = -1;
    if (variable_struct_exists(definition, "icon_sprite")) reward_sprite = definition.icon_sprite;
    if ((reward_sprite == -1 || !sprite_exists(reward_sprite)) && variable_struct_exists(definition, "weapon_sprite")) reward_sprite = definition.weapon_sprite;
    if ((reward_sprite == -1 || !sprite_exists(reward_sprite)) && variable_struct_exists(definition, "sprite_idle")) reward_sprite = definition.sprite_idle;
    if (reward_sprite == -1 || !sprite_exists(reward_sprite)) reward_sprite = spr_error;

    if (reward_sprite != -1 && sprite_exists(reward_sprite))
    {
        var _bbox_left = sprite_get_bbox_left(reward_sprite);
        var _bbox_top = sprite_get_bbox_top(reward_sprite);
        var _bbox_width = sprite_get_bbox_right(reward_sprite) - _bbox_left + 1;
        var _bbox_height = sprite_get_bbox_bottom(reward_sprite) - _bbox_top + 1;
        var _reward_scale = min((_size - 10) / _bbox_width, (_size - 10) / _bbox_height);
        draw_sprite_part_ext(reward_sprite, icon_spin_frame(reward_sprite), _bbox_left, _bbox_top, _bbox_width, _bbox_height,
            _left + ((_size - _bbox_width * _reward_scale) * 0.5), _top + ((_size - _bbox_height * _reward_scale) * 0.5),
            _reward_scale, _reward_scale, c_white, 1);
    }

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(_amber);
    draw_text(_left + _size - 5, _top + _size - 4, "x" + string(_reward.quantity));
}

function draw_quest_contract_reward_chip(_left, _top, _width, _text, _amber)
{
    draw_set_color(make_color_rgb(28, 25, 14));
    draw_item_info_chamfer_fill(_left, _top, _left + _width, _top + 34, 7);
    draw_set_color(_amber);
    draw_border_frame2_path(_left, _top, _left + _width, _top + 34, 7);
    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_left + _width * 0.5, _top + 17, _text);
}

function draw_quest_contract_popup()
{
    var definition = quest_get_definition(quest_contract_popup_state.quest_key);
    if (is_undefined(definition)) return;
    var progress = quest_get_progress(quest_contract_popup_state.quest_key);
    var rect = quest_contract_popup_rect();
    var amber = make_color_rgb(222, 154, 48);
    var bright_amber = make_color_rgb(255, 191, 73);

    draw_set_alpha(0.76);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(4, 6, 4));
    draw_item_info_chamfer_fill(rect.left + 7, rect.top + 7, rect.right + 7, rect.bottom + 7, 18);
    draw_set_color(make_color_rgb(10, 14, 10));
    draw_item_info_chamfer_fill(rect.left, rect.top, rect.right, rect.bottom, 18);
    draw_set_color(amber);
    draw_border_frame2(rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top);
    draw_set_color(make_color_rgb(52, 37, 14));
    draw_item_info_chamfer_fill(rect.left + 5, rect.top + 5, rect.right - 5, rect.top + 59, 13);
    draw_set_color(amber);
    draw_line(rect.left + 5, rect.top + 62, rect.right - 5, rect.top + 62);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_terminal_small);
    draw_set_color(bright_amber);
    draw_text(rect.left + 24, rect.top + 18, definition.title);

    draw_set_font(fnt_terminal_tiny);
    draw_set_color(amber);
    draw_text_ext(rect.left + 24, rect.top + 78, definition.description, 21, rect.right - rect.left - 48);
    draw_line(rect.left + 24, rect.top + 151, rect.right - 24, rect.top + 151);
    draw_text(rect.left + 24, rect.top + 164, "OBJECTIVES:");
    for (var i = 0; i < array_length(definition.objectives); i++)
    {
        var objective = definition.objectives[i];
        var current = is_undefined(progress) ? 0 : progress.objectives[i];
        var complete = current >= objective.amount;
        var row_left = rect.left + 24;
        var row_top = rect.top + 190 + i * 39;
        var row_right = rect.right - 24;
        var row_bottom = row_top + 32;
        draw_set_color(make_color_rgb(20, 22, 15));
        draw_item_info_chamfer_fill(row_left, row_top, row_right, row_bottom, 7);
        draw_set_color(amber);
        draw_border_frame2_path(row_left, row_top, row_right, row_bottom, 7);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text(row_left + 13, (row_top + row_bottom) * 0.5, objective.text);
        draw_set_halign(fa_right);
        draw_text(row_right - 38, (row_top + row_bottom) * 0.5, string(current) + "/" + string(objective.amount));

        var check_left = row_right - 27;
        var check_top = row_top + 7;
        var check_right = row_right - 9;
        var check_bottom = row_bottom - 7;
        draw_set_color(complete ? make_color_rgb(65, 220, 102) : make_color_rgb(215, 67, 55));
        draw_rectangle(check_left, check_top, check_right, check_bottom, true);
        if (complete)
        {
            draw_line(check_left + 3, check_top + 8, check_left + 7, check_bottom - 3);
            draw_line(check_left + 7, check_bottom - 3, check_right - 3, check_top + 3);
        }
        else
        {
            draw_line(check_left + 4, check_top + 3, check_right - 4, check_bottom - 3);
            draw_line(check_right - 4, check_top + 3, check_left + 4, check_bottom - 3);
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(amber);
    var reward_top = rect.top + 318;
    draw_line(rect.left + 24, reward_top - 12, rect.right - 24, reward_top - 12);
    draw_text(rect.left + 24, reward_top, "REWARDS:");
    var slot_size = 54;
    var slot_gap = 7;
    var grid_left = rect.left + 24;
    var grid_top = reward_top + 28;
    var item_reward_count = array_length(definition.rewards.items);
    var reward_count = item_reward_count + (definition.rewards.cash > 0 ? 1 : 0);
    for (var item_index = 0; item_index < min(10, reward_count); item_index++)
    {
        var column = item_index mod 5;
        var row = floor(item_index / 5);
        var reward = item_index < item_reward_count
            ? definition.rewards.items[item_index]
            : { item_key: "cash", quantity: definition.rewards.cash };
        draw_quest_contract_reward_item(reward,
            grid_left + column * (slot_size + slot_gap), grid_top + row * (slot_size + slot_gap), slot_size, amber);
    }

    var chip_left = rect.left + 340;
    var chip_top = grid_top;
    var reputation = variable_struct_exists(definition, "reputation") ? definition.reputation : 5;
    if (reputation > 0)
        draw_quest_contract_reward_chip(chip_left, chip_top, rect.right - chip_left - 24,
            "+" + string(reputation) + " REP", amber);

    var button_gap = 14;
    var button_left = rect.left + 28;
    var button_right = rect.right - 28;
    var button_top = rect.bottom - 70;
    var button_width = (button_right - button_left - button_gap) * 0.5;
    var labels = [quest_contract_popup_state.claim ? "CLAIM REWARDS" : "ACCEPT", "NOT RIGHT NOW"];
    for (var button = 0; button < 2; button++)
    {
        var left = button_left + button * (button_width + button_gap);
        var selected = quest_contract_popup_state.selection == button;
        draw_set_color(selected ? make_color_rgb(68, 48, 18) : make_color_rgb(18, 20, 14));
        draw_item_info_chamfer_fill(left, button_top, left + button_width, rect.bottom - 24, 9);
        draw_set_color(selected ? bright_amber : amber);
        draw_border_frame2_path(left, button_top, left + button_width, rect.bottom - 24, 9);
        draw_set_alpha(0.3);
        draw_border_frame2_path(left + 3, button_top + 3, left + button_width - 3, rect.bottom - 27, 6);
        draw_set_alpha(1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(left + button_width * 0.5, (button_top + rect.bottom - 24) * 0.5, labels[button]);
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(global.ui_text_color);
}
