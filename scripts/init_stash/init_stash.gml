function init_stash()
{
    stash = {
        grid_width: 10,
        grid_height: 14,
        items: [],
        held_item: undefined,
        held_source: "",
        equipped_bag_item: undefined,
        equipped_weapon_item: undefined,
        equipped_weapon_2_item: undefined,
        equipped_armor_head_item: undefined,
        equipped_armor_chest_item: undefined,
		equipped_secure_container_item: { item_key: "small_container", quantity: 1, x: 0, y: 0, rotation: 0 },
        hover_x: -1,
        hover_y: -1,
        hover_container: "",
        backpack: {
            grid_width: 0,
            grid_height: 0,
            items: []
        },
        secure_container: {
            grid_width: 2,
            grid_height: 2,
            items: []
        }
    };

}
