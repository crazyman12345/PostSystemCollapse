function raid_inventory_clear_held()
{
    if (!is_undefined(raid.inventory_item) && !is_undefined(raid.inventory_container))
        array_push(raid.inventory_container.items, raid.inventory_item);
    else if (!is_undefined(raid.inventory_item) && raid.inventory_equipment_slot != -1)
        raid_inventory_set_equipped_item(raid.inventory_equipment_slot, raid.inventory_item);

    raid.inventory_item = undefined;
    raid.inventory_container = undefined;
    raid.inventory_equipment_slot = -1;
}
