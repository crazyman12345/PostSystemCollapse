function player_skill_add_xp(_skill_key, _amount)
{
    if (!variable_struct_exists(player_skills, _skill_key))
        return false;
    var skill =
        variable_struct_get(
            player_skills,
            _skill_key
        );
    var previous_level = skill.level;
    skill.xp += _amount;
    skill.level = skill_get_level_from_xp(skill.xp);
    if (_amount > 0) skill_notification_add_xp(_skill_key, _amount);
    for (var level = previous_level + 1; level <= skill.level; level++)
    {
        skill_notification_queue_level_up(_skill_key, level);
    }
    variable_struct_set(
        player_skills,
        _skill_key,
        skill
    );
    if (_skill_key == "vitality" && skill.level != previous_level) player_health_refresh_maximums(true);
    save_mark_dirty();
    return true;
}

function skill_notifications_init()
{
    skill_xp_notifications = [];
    skill_level_up_queue = [];
    skill_level_up_notification = undefined;
}

function skill_notification_add_xp(_skill_key, _amount)
{
    for (var i = 0; i < array_length(skill_xp_notifications); i++)
    {
        var notification = skill_xp_notifications[i];
        if (notification.skill_key == _skill_key)
        {
            notification.amount += _amount;
            notification.remaining = 120;
            return;
        }
    }

    array_push(skill_xp_notifications, {
        skill_key: _skill_key,
        amount: _amount,
        age: 0,
        remaining: 120
    });
}

function skill_notification_queue_level_up(_skill_key, _level)
{
    array_push(skill_level_up_queue, {
        skill_key: _skill_key,
        level: _level,
        age: 0
    });
}

function skill_notifications_update()
{
    for (var i = array_length(skill_xp_notifications) - 1; i >= 0; i--)
    {
        var notification = skill_xp_notifications[i];
        notification.age += frame_scale;
        notification.remaining -= frame_scale;
        if (notification.remaining <= 0) array_delete(skill_xp_notifications, i, 1);
    }

    if (is_undefined(skill_level_up_notification) && array_length(skill_level_up_queue) > 0)
    {
        skill_level_up_notification = skill_level_up_queue[0];
        array_delete(skill_level_up_queue, 0, 1);
        audio_play_sound(snd_level_up, 0, false);
    }

    if (!is_undefined(skill_level_up_notification))
    {
        skill_level_up_notification.age += frame_scale;
        if (skill_level_up_notification.age >= 225) skill_level_up_notification = undefined;
    }
}

function skill_notification_get_icon(_skill_key)
{
    for (var i = 0; i < array_length(hideout_skill_tabs); i++)
    {
        if (hideout_skill_tabs[i].key == _skill_key) return hideout_skill_tabs[i].icon;
    }
    return -1;
}

function skill_notification_get_name(_skill_key)
{
    var skill = skill_db_get(_skill_key);
    if (is_undefined(skill)) return string(_skill_key);

    var name = string_lower(skill.name);
    return string_upper(string_copy(name, 1, 1)) + string_delete(name, 1, 1);
}

function skill_notifications_draw()
{
    var gui_w = display_get_gui_width();
    var panel_right = gui_w - 30;
    var panel_width = 300;
    var row_height = 36;
    var stack_top = quest_tracker_is_visible() ? quest_tracker_get_panel_bottom() + 12 : 88;
    if (array_length(quest_notification_queue) > 0) stack_top = quest_notifications_get_bottom() + 12;

    draw_set_font(fnt_ascii);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    for (var i = 0; i < array_length(skill_xp_notifications); i++)
    {
        var notification = skill_xp_notifications[i];
        var alpha = clamp(notification.remaining / 30, 0, 1);
        var rise = 4 * clamp(notification.age / 20, 0, 1);
        var top = stack_top + i * (row_height + 5) + 4 - rise;
        var left = panel_right - panel_width;

        draw_set_alpha(alpha);
        draw_terminal_rectangle(left, top, panel_right, top + row_height, c_green, 0.88);

        var icon = skill_notification_get_icon(notification.skill_key);
        var text_left = left + 12;
        if (icon != -1)
        {
            var icon_size = 20;
            var icon_scale = min(icon_size / sprite_get_width(icon), icon_size / sprite_get_height(icon));
            draw_sprite_ext(icon, icon_spin_frame(icon), left + 20, top + row_height * 0.5, icon_scale, icon_scale, 0, c_green, alpha);
            text_left = left + 38;
        }

        draw_set_color(global.ui_text_color);
        draw_text(text_left, top + row_height * 0.5, "+" + string(notification.amount) + " " + skill_notification_get_name(notification.skill_key) + " XP");
    }

    if (!is_undefined(skill_level_up_notification))
    {
        var notification = skill_level_up_notification;
        var alpha = min(clamp(notification.age / 15, 0, 1), clamp((225 - notification.age) / 30, 0, 1));
        var level_panel_width = 620;
        var panel_height = 132;
        var left = (gui_w - level_panel_width) * 0.5;
        var top = 58;
        var right = left + level_panel_width;

        draw_set_alpha(alpha * 0.35);
        draw_terminal_rectangle(left, top, right, top + panel_height, c_green, 0.55);
        draw_set_alpha(alpha);
        draw_set_color(c_green);
        draw_line(left + 20, top + 48, right - 20, top + 48);

        draw_set_font(fnt_terminal_medium);
        draw_set_halign(fa_center);
        draw_set_color(global.ui_text_color);
        draw_text((left + right) * 0.5, top + 25, "SKILL LEVEL UP");

        var icon = skill_notification_get_icon(notification.skill_key);
        var content_width = 0;
        draw_set_font(fnt_terminal_small);
        var level_text = skill_notification_get_name(notification.skill_key) + " - Level " + string(notification.level);
        content_width = string_width(level_text);
        if (icon != -1) content_width += 52;
        var content_left = (gui_w - content_width) * 0.5;

        if (icon != -1)
        {
            var icon_size = 38;
            var icon_scale = min(icon_size / sprite_get_width(icon), icon_size / sprite_get_height(icon));
            draw_sprite_ext(icon, icon_spin_frame(icon), content_left + icon_size * 0.5, top + 90, icon_scale, icon_scale, 0, c_green, alpha);
            content_left += 52;
        }

        draw_set_halign(fa_left);
        draw_text(content_left, top + 90, level_text);
    }

    draw_set_alpha(1);
    draw_set_color(global.ui_text_color);
    draw_set_font(fnt_terminal);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
