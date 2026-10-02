function draw_loadout_equipment_panel(_member)
{
    var focus = false;

    if (loadout_focus == LoadoutFocus.EQUIPMENT)
    {
        focus = true;
    }


    terminal_panel(
        60,
        150,
        760,
        410,
        "EQUIPMENT",
        focus
    );


    draw_set_font(fnt_terminal_small);


    // ==============================
    // FOCUSED ITEM INFO
    // ==============================

    if (loadout_focus == LoadoutFocus.EQUIPMENT)
    {
        switch (equipment_slot_index)
        {
            case EquipmentSlot.HEAD:
            {
                if (_member.armor_head != "")
                {
                    loadout_focused_item_key =
                        _member.armor_head;
                }
            }
            break;


            case EquipmentSlot.WEAPON:
            {
                if (_member.weapon != "")
                {
                    loadout_focused_item_key =
                        _member.weapon;
                }
            }
            break;


            case EquipmentSlot.CHEST:
            {
                if (_member.armor_chest != "")
                {
                    loadout_focused_item_key =
                        _member.armor_chest;
                }
            }
            break;


            case EquipmentSlot.BAG:
            {
                if (_member.bag != "")
                {
                    loadout_focused_item_key =
                        _member.bag;
                }
            }
            break;
        }
    }


    // ==============================
    // CHARACTER ASCII
    // ==============================

    var ascii_x = 385;
    var ascii_y = 355;
    var ascii_line_height = 18;


    for (
        var i = 0;
        i < array_length(_member.ascii);
        i++
    )
    {
        draw_text(
            ascii_x,
            ascii_y + (i * ascii_line_height),
            _member.ascii[i]
        );
    }


    // ==============================
    // HEAD
    // ==============================

    draw_equipment_slot(
        315,
        205,
        250,
        70,
        "HEAD",
        _member.armor_head,

        loadout_focus == LoadoutFocus.EQUIPMENT
        && equipment_slot_index == EquipmentSlot.HEAD
    );


    // ==============================
    // WEAPON
    // ==============================

    draw_equipment_slot(
        90,
        345,
        235,
        70,
        "WEAPON",
        _member.weapon,

        loadout_focus == LoadoutFocus.EQUIPMENT
        && equipment_slot_index == EquipmentSlot.WEAPON
    );


    // ==============================
    // CHEST
    // ==============================

    draw_equipment_slot(
        555,
        345,
        235,
        70,
        "CHEST",
        _member.armor_chest,

        loadout_focus == LoadoutFocus.EQUIPMENT
        && equipment_slot_index == EquipmentSlot.CHEST
    );


    // ==============================
    // BAG
    // ==============================

    draw_equipment_slot(
        315,
        475,
        250,
        70,
        "BAG",
        _member.bag,

        loadout_focus == LoadoutFocus.EQUIPMENT
        && equipment_slot_index == EquipmentSlot.BAG
    );


    draw_set_font(fnt_terminal);
}