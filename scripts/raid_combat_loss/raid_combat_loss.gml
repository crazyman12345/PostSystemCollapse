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

    crew[raid.crew_index] = member;


    // ==========================================
    // LOSE RAID LOOT
    // ==========================================

    raid.bag = {};


    // ==========================================
    // STOP RAID
    // ==========================================

    raid.active = false;

    raid.pending_action =
        undefined;

    raid.extract_active =
        false;

    raid.doors_active =
        false;

    raid_enemies = [];
    raid_bullets = [];
    raid_enemy_bullets = [];
    raid_doors = [];


    // ==========================================
    // RESULT SCREEN
    // ==========================================

    raid.result_title =
        "YOU FUCKING SUCK!";

    raid.result_message =
        member.name
        + " was critically injured.\n"
        + "All raid loot was lost.";

    log_add(
        "Raid failed."
    );

    raid.mode =
        RaidMode.RESULT;

    menu_index = 0;
}