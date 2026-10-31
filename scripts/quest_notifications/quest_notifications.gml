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
            for (var entry_index = 0; entry_index < array_length(existing.entries); entry_index++)
            {
                var entry = existing.entries[entry_index];
                if (entry.key != _key) continue;
                entry.title = _title;
                entry.message = _message;
                existing.age = 0;
                existing.remaining = 150;
                return;
            }
        }
    }

    var new_entry = { title: _title, message: _message, key: _key };
    var queue_count = array_length(quest_notification_queue);
    if (queue_count > 0 && quest_notification_queue[queue_count - 1].age <= 0)
    {
        var current = quest_notification_queue[queue_count - 1];
        array_push(current.entries, new_entry);
        current.remaining = 150;
        return;
    }

    array_push(quest_notification_queue, { entries: [new_entry], age: 0, remaining: 150 });
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

function quest_notification_line_count(_text)
{
    var _line_count = 1;
    for (var _i = 1; _i <= string_length(_text); _i++)
        if (string_char_at(_text, _i) == "\n") _line_count++;
    return _line_count;
}

function quest_notification_get_height(_notification)
{
    draw_set_font(fnt_quest_notification);
    var _text_width = 800;
    var _line_separation = 32;
    var _height = 0;
    for (var _entry_index = 0; _entry_index < array_length(_notification.entries); _entry_index++)
    {
        var _entry = _notification.entries[_entry_index];
        var _title_height = string_height_ext(_entry.title, _line_separation, _text_width);
        var _message_height = string_height_ext(_entry.message, _line_separation, _text_width);
        _height += max(104, 14 + _title_height + 10 + _message_height + 14);
    }
    return _height;
}

function quest_notifications_get_top()
{
    return quest_tracker_is_visible() ? quest_tracker_get_panel_bottom() + 12 : 30;
}

function quest_notifications_get_bottom()
{
    var _bottom = quest_notifications_get_top();
    for (var _i = 0; _i < array_length(quest_notification_queue); _i++)
        _bottom += quest_notification_get_height(quest_notification_queue[_i]) + 12;
    return _bottom - 12;
}

function quest_notifications_draw()
{
    var panel_right = display_get_gui_width() - 30;
    var panel_width = 840;
    var text_width = panel_width - 40;
    var line_separation = 32;
    var top = quest_notifications_get_top();
    draw_set_font(fnt_quest_notification);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var i = 0; i < array_length(quest_notification_queue); i++)
    {
        var notification = quest_notification_queue[i];
        var alpha = clamp(notification.remaining / 25, 0, 1);
        var row_height = quest_notification_get_height(notification);
        var left = panel_right - panel_width;
        draw_set_alpha(alpha * 0.88);
        draw_set_color(c_black);
        draw_rectangle(left, top, panel_right, top + row_height, false);
        draw_set_alpha(alpha);
        draw_set_color(c_green);
        draw_rectangle(left, top, panel_right, top + row_height, true);

        var entry_top = top;
        for (var entry_index = 0; entry_index < array_length(notification.entries); entry_index++)
        {
            var entry = notification.entries[entry_index];
            var title_height = string_height_ext(entry.title, line_separation, text_width);
            var message_height = string_height_ext(entry.message, line_separation, text_width);
            var entry_height = max(104, 14 + title_height + 10 + message_height + 14);
            draw_set_color(global.ui_text_color);
            draw_text_ext(left + 20, entry_top + 14, entry.title, line_separation, text_width);
            draw_set_color(global.ui_text_color);
            draw_text_ext(left + 20, entry_top + 24 + title_height, entry.message, line_separation, text_width);
            entry_top += entry_height;
        }
        top += row_height + 12;
    }

    draw_set_alpha(1);
    draw_set_color(global.ui_text_color);
    draw_set_font(fnt_terminal);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
