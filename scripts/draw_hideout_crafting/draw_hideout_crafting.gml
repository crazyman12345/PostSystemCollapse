function draw_hideout_crafting(_skill_key, _x1, _y1, _x2, _y2)
{
    if (crafting_minigame_state.active)
    {
        draw_weapon_crafting_minigame();
        return;
    }

    var gap = 15;
    var panel_top = _y1 + 80;
    var panel_height = _y2 - panel_top - 20;
    var list_left = _x1 + 20;
    var content_right = _x2 - 20;
    var panel_width = floor((content_right - list_left - gap) * 0.5);
    var details_left = list_left + panel_width + gap;
    var details_width = content_right - details_left;
    var padding = 20;
    var row_height = 64;
    var row_gap = 8;
    var row_pitch = row_height + row_gap;
    var list_row_height = 76;
    var list_row_pitch = list_row_height + row_gap;
    var list_icon_width = 120;
    var skill_info_height = 220;
    var skill_info_top = panel_top + 50;
    var list_top = skill_info_top + skill_info_height + 12;

    var all_recipes = recipe_get_for_skill(_skill_key);
    var recipes = [];
    for (var recipe_index = 0; recipe_index < array_length(all_recipes); recipe_index++)
    {
        var available_recipe = all_recipes[recipe_index];
        if (recipe_is_unlocked(_skill_key, available_recipe)) array_push(recipes, available_recipe);
    }

    var recipe_count = array_length(recipes);
    var visible_rows = max(1, floor((panel_height - 115 - skill_info_height - 12) / list_row_pitch));

    draw_set_font(fnt_terminal_small);
    draw_set_color(global.ui_text_color);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    terminal_panel(list_left, panel_top, panel_width, panel_height, "RECIPES");
    terminal_panel(details_left, panel_top, details_width, panel_height, "RECIPE DETAILS");
    draw_crafting_skill_progress(_skill_key, list_left + padding, skill_info_top,
        list_left + panel_width - padding, skill_info_height);

    if (recipe_count == 0)
    {
        draw_text(list_left + padding, list_top, "NO RECIPES UNLOCKED");
        draw_text(details_left + padding, list_top, "UNLOCK A RECIPE TO VIEW ITS DETAILS");
        return;
    }

    var selected_index = clamp(crafting_recipe_index, 0, recipe_count - 1);
    var last_recipe = min(crafting_recipe_scroll + visible_rows, recipe_count);

    for (var i = crafting_recipe_scroll; i < last_recipe; i++)
    {
        var listed_recipe = recipes[i];
        var output_item = item_get(listed_recipe.output.item_key);
        var selected = selected_index == i;
        var row_top = list_top + (i - crafting_recipe_scroll) * list_row_pitch;
        var row_left = list_left + padding;
        var row_right = list_left + panel_width - padding;
        var row_color = selected ? global.ui_interactive_color : global.ui_text_color;

        draw_terminal_rectangle(row_left, row_top, row_right, row_top + list_row_height, row_color, selected ? 0.98 : 0.84);
        draw_set_color(row_color);
        draw_line(row_left + list_icon_width, row_top + 6, row_left + list_icon_width, row_top + list_row_height - 6);
        draw_crafting_item_icon(output_item, row_left + 8, row_top + 6, list_icon_width - 16, list_row_height - 12);

        draw_text(row_left + list_icon_width + 16, row_top + 10, listed_recipe.name);
        var tier_text = variable_struct_exists(listed_recipe, "crafting_tier")
            ? "TIER " + string(listed_recipe.crafting_tier)
            : "TIER -";
        var xp_text = variable_struct_exists(listed_recipe, "xp")
            ? "CRAFTING XP " + string(listed_recipe.xp)
            : "CRAFTING XP 0";
        draw_set_font(fnt_terminal_tiny);
        draw_text(row_left + list_icon_width + 16, row_top + 44, tier_text + "    " + xp_text);
        draw_set_font(fnt_terminal_small);
        draw_set_halign(fa_right);
        draw_set_valign(fa_middle);
        draw_text(row_right - 16, row_top + list_row_height * 0.5, "X" + string(listed_recipe.output.quantity));
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    draw_set_color(global.ui_text_color);
    draw_set_halign(fa_right);
    draw_text(list_left + panel_width - padding, panel_top + panel_height - 48,
        string(selected_index + 1) + " / " + string(recipe_count));
    draw_set_halign(fa_left);

    var recipe = recipes[selected_index];
    var recipe_item = item_get(recipe.output.item_key);
    var details_x = details_left + padding;
    var details_right = details_left + details_width - padding;
    var header_top = panel_top + 50;
    var header_height = 112;
    var icon_size = 88;

    draw_set_color(global.ui_interactive_color);
    terminal_box(details_x, header_top, details_right - details_x, header_height);
    draw_set_font(fnt_terminal_medium);
    draw_set_valign(fa_middle);
    draw_text(details_x + 12 + icon_size + 20, header_top + header_height * 0.5, recipe.name);
    draw_set_font(fnt_terminal_small);
    draw_set_valign(fa_top);

    var icon_left = details_x + 12;
    var icon_top = header_top + (header_height - icon_size) * 0.5;
    draw_set_color(global.ui_text_color);
    terminal_box(icon_left, icon_top, icon_size, icon_size);
    draw_crafting_item_icon(recipe_item, icon_left + 8, icon_top + 8, icon_size - 16, icon_size - 16);

    var ingredients_title_y = header_top + header_height + 24;
    draw_set_color(global.ui_text_color);
    draw_text(details_x, ingredients_title_y, "INGREDIENTS");

    var ingredients_top = ingredients_title_y + 40;
    for (var ingredient_index = 0; ingredient_index < array_length(recipe.ingredients); ingredient_index++)
    {
        var ingredient = recipe.ingredients[ingredient_index];
        var ingredient_item = item_get(ingredient.item_key);
        var owned = stash_get_quantity(ingredient.item_key);
        var ingredient_ok = owned >= ingredient.quantity;
        var ingredient_top = ingredients_top + ingredient_index * row_pitch;
        var ingredient_color = ingredient_ok ? global.ui_interactive_color : c_red;
        var status_size = 40;
        var status_left = details_right - status_size - 12;

        draw_terminal_rectangle(details_x, ingredient_top, details_right, ingredient_top + row_height,
            ingredient_ok ? global.ui_text_color : c_gray, 0.84);
        draw_set_color(global.ui_text_color);
        draw_line(details_x + row_height, ingredient_top + 6, details_x + row_height, ingredient_top + row_height - 6);
        draw_crafting_item_icon(ingredient_item, details_x + 8, ingredient_top + 8, row_height - 16, row_height - 16);

        draw_set_valign(fa_middle);
        draw_set_color(global.ui_text_color);
        draw_text(details_x + row_height + 16, ingredient_top + row_height * 0.5, ingredient_item.name);
        draw_set_halign(fa_right);
        draw_text(status_left - 18, ingredient_top + row_height * 0.5,
            string(owned) + " / " + string(ingredient.quantity));
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        draw_crafting_requirement_status(status_left, ingredient_top + (row_height - status_size) * 0.5,
            status_size, ingredient_ok, ingredient_color);
    }

    var craft_top = ingredients_top + array_length(recipe.ingredients) * row_pitch + 22;
    var craft_height = 60;
    var can_craft = recipe_can_craft(_skill_key, recipe);
    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);
    var craft_hovered = point_in_rectangle(mouse_gui_x, mouse_gui_y, details_x, craft_top, details_right, craft_top + craft_height);
    var craft_color = can_craft ? global.ui_interactive_color : c_gray;
    var craft_border_color = craft_hovered ? c_white : craft_color;

    draw_terminal_rectangle(details_x, craft_top, details_right, craft_top + craft_height, craft_border_color,
        craft_hovered ? 1 : 0.86);
    draw_set_color(craft_color);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text((details_x + details_right) * 0.5, craft_top + craft_height * 0.5,
        craft_hovered ? "> CRAFT <" : "CRAFT");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    if (crafting_message != "")
    {
        draw_set_color(global.ui_text_color);
        draw_text(details_x, panel_top + panel_height - 48, crafting_message);
    }
}

function draw_crafting_item_icon(_item, _left, _top, _width, _height)
{
    var render_sprite = -1;
    if (variable_struct_exists(_item, "icon_sprite") && _item.icon_sprite != -1)
        render_sprite = _item.icon_sprite;
    else if (variable_struct_exists(_item, "weapon_sprite") && _item.weapon_sprite != -1)
        render_sprite = _item.weapon_sprite;
    else if (variable_struct_exists(_item, "sprite_idle") && _item.sprite_idle != -1)
        render_sprite = _item.sprite_idle;

    if (render_sprite == -1 || !sprite_exists(render_sprite))
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_left + _width * 0.5, _top + _height * 0.5, "?");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        return;
    }

    var _bbox_left = sprite_get_bbox_left(render_sprite);
    var _bbox_top = sprite_get_bbox_top(render_sprite);
    var _bbox_width = sprite_get_bbox_right(render_sprite) - _bbox_left + 1;
    var _bbox_height = sprite_get_bbox_bottom(render_sprite) - _bbox_top + 1;
    var icon_scale = min(_width / _bbox_width, _height / _bbox_height);

    draw_sprite_part_ext(render_sprite, icon_spin_frame(render_sprite), _bbox_left, _bbox_top, _bbox_width, _bbox_height,
        _left + (_width - _bbox_width * icon_scale) * 0.5,
        _top + (_height - _bbox_height * icon_scale) * 0.5,
        icon_scale, icon_scale, c_white, 1);
}

function draw_crafting_skill_progress(_skill_key, _left, _top, _right, _height)
{
    var _skill_definition = skill_db_get(_skill_key);
    var _skill_progress = variable_struct_get(player_skills, _skill_key);
    var _level_xp_start = skill_xp_for_level(_skill_progress.level);
    var _next_level_xp = skill_xp_for_level(_skill_progress.level + 1);
    var _level_xp = _skill_progress.xp - _level_xp_start;
    var _level_xp_required = max(1, _next_level_xp - _level_xp_start);
    var _progress = clamp(_level_xp / _level_xp_required, 0, 1);
    var _icon = -1;
    switch (_skill_key)
    {
        case "gunmaking": _icon = spr_weapon_workbench; break;
        case "armorcrafting": _icon = spr_armor_workbench; break;
        case "medical_crafting": _icon = spr_medical_bench; break;
        case "drugmaking": _icon = spr_drugtable; break;
    }

    draw_set_color(global.ui_text_color);
    terminal_box(_left, _top, _right - _left, _height);

    var _icon_width = 200;
    draw_line(_left + _icon_width, _top + 8, _left + _icon_width, _top + _height - 8);
    if (_icon != -1 && sprite_exists(_icon))
    {
        var _icon_scale = 170 / max(sprite_get_width(_icon), sprite_get_height(_icon));
        draw_sprite_ext(_icon, icon_spin_frame(_icon),
            _left + _icon_width * 0.5, _top + _height * 0.5,
            _icon_scale, _icon_scale, 0, c_white, 1);
    }

    var _content_left = _left + _icon_width + 18;
    var _content_right = _right - 18;
    draw_set_font(fnt_terminal_small);
    draw_set_color(global.ui_text_color);
    draw_text(_content_left, _top + 50,
        _skill_definition.name + " LEVEL: " + string(_skill_progress.level));
    draw_set_font(fnt_terminal_tiny);
    draw_text(_content_left, _top + 97, "XP NEEDED");

    var _bar_top = _top + 130;
    var _bar_bottom = _bar_top + 26;
    draw_set_color(global.hideout_border_subtle_color);
    draw_rectangle(_content_left, _bar_top, _content_right, _bar_bottom, false);
    draw_set_color(global.ui_interactive_color);
    draw_rectangle(_content_left, _bar_top,
        _content_left + (_content_right - _content_left) * _progress, _bar_bottom, false);
    draw_set_color(global.ui_text_color);
    draw_rectangle(_content_left, _bar_top, _content_right, _bar_bottom, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text((_content_left + _content_right) * 0.5, (_bar_top + _bar_bottom) * 0.5,
        string(_level_xp) + " / " + string(_level_xp_required));
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_terminal_small);
}

function draw_crafting_requirement_status(_left, _top, _size, _has_enough, _color)
{
    draw_terminal_rectangle(_left, _top, _left + _size, _top + _size, _color, 0.9);
    draw_set_color(_color);
    var center_x = _left + _size * 0.5;
    var center_y = _top + _size * 0.5;

    if (_has_enough)
    {
        draw_line_width(center_x - 9, center_y, center_x - 2, center_y + 8, 3);
        draw_line_width(center_x - 2, center_y + 8, center_x + 11, center_y - 9, 3);
    }
    else
    {
        draw_line_width(center_x - 9, center_y - 9, center_x + 9, center_y + 9, 3);
        draw_line_width(center_x + 9, center_y - 9, center_x - 9, center_y + 9, 3);
    }
}
