function raid_combat_loss()
{
    var member = crew[raid.crew_index];

    // ==========================================
    // CRITICALLY INJURE CREW MEMBER
    // ==========================================

    member.status =
        CrewStatus.CRITICALLY_INJURED;

    member.injury_end_time =
        current_time
        + (5 * 60 * 1000);

    member.weapon = "";
    member.weapon_2 = "";
    member.armor_head = "";
    member.armor_chest = "";
    member.bag = "";
    crew[raid.crew_index] = member;


    // ==========================================
    // LOSE RAID LOOT
    // ==========================================

    // A held secure-container item is still protected. Items held from the
    // backpack or a loot container are lost with the raid instead of being
    // left detached from every container.
    if (!is_undefined(raid.inventory_item)
    && raid.inventory_container == stash.secure_container)
    {
        array_push(stash.secure_container.items, raid.inventory_item);
    }

    stash.backpack.items = [];
    stash.backpack.grid_width = 0;
    stash.backpack.grid_height = 0;
    stash.equipped_bag_item = undefined;
    stash.equipped_weapon_item = undefined;
    stash.equipped_weapon_2_item = undefined;
    stash.equipped_armor_head_item = undefined;
    stash.equipped_armor_chest_item = undefined;
    raid.inventory_item = undefined;
    raid.inventory_container = undefined;
    raid.inventory_rotation = 0;
    raid.active_loot_container = undefined;
    raid_lootables = [];
    raid.last_loot = [];
    raid.loot_index = 0;


    // ==========================================
    // STOP RAID
    // ==========================================

    raid.active = false;
    raid_reset_active_weapon();

    raid.pending_action =
        undefined;

    raid.extract_active =
        false;

    raid.doors_active =
        false;

    raid_enemies = [];
    raid_bullets = [];
    raid_enemy_bullets = [];
    raid_ring_hazards = [];
    raid_enemy_death_effects = [];
    raid_doors = [];


    // ==========================================
    // RESULT SCREEN
    // ==========================================

    raid.result_title =
        "YOU FUCKING SUCK!";

    raid.result_message =
        member.name
        + " was critically injured.\n"
        + "Backpack and equipment lost. Secure contents kept.";

    log_add(
        "Raid failed."
    );

    raid.mode =
        RaidMode.RESULT;

    menu_index = 0;
}
