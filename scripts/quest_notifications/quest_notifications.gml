function quest_notifications_init()
{
    quest_notification_queue = [];
}

function quest_notification_add(_title, _message, _key = "")
{
    if (_key != "")
    {
        for (var i = 0; i < array_length(quest_notification_queue); i++)
        {
            var existing = quest_notification_queue[i];
            if (existing.key != _key) continue;
            existing.title = _title;
            existing.message = _message;
            existing.age = 0;
            existing.remaining = 150;
            return;
        }
    }

    array_push(quest_notification_queue, { title: _title, message: _message, key: _key, age: 0, remaining: 150 });
    if (array_length(quest_notification_queue) > 3) array_delete(quest_notification_queue, 0, 1);
}

function quest_notifications_update()
{
    for (var i = array_length(quest_notification_queue) - 1; i >= 0; i--)
    {
        var notification = quest_notification_queue[i];
        notification.age += frame_scale;
        notification.remaining -= frame_scale;
        if (notification.remaining <= 0) array_delete(quest_notification_queue, i, 1);
    }
}

function quest_notifications_draw()
{
    var panel_right = display_get_gui_width() - 30;
    if (quest_tracker_is_visible()) panel_right -= 480;
    var panel_width = 420;
    var row_height = 52;
    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var i = 0; i < array_length(quest_notification_queue); i++)
    {
        var notification = quest_notification_queue[i];
        var alpha = clamp(notification.remaining / 25, 0, 1);
        var top = 245 + i * (row_height + 6);
        var left = panel_right - panel_width;
        draw_set_alpha(alpha * 0.88);
        draw_set_color(c_black);
        draw_rectangle(left, top, panel_right, top + row_height, false);
        draw_set_alpha(alpha);
        draw_set_color(c_green);
        draw_rectangle(left, top, panel_right, top + row_height, true);
        draw_set_color(c_lime);
        draw_text(left + 10, top + 7, notification.title);
        draw_set_color(c_green);
        draw_text(left + 10, top + 28, notification.message);
    }

    draw_set_alpha(1);
    draw_set_color(c_lime);
    draw_set_font(fnt_terminal);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
