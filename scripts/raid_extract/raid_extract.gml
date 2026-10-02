function raid_extract()
{
    log_add("EXTRACTION SUCCESSFUL");

    raid.result_title =
        "EXTRACTION SUCCESSFUL";

    raid.result_message =
        "All items secured.";

    raid_secure_bag();

    raid.active = false;

    raid.extract_active = false;
    raid.doors_active = false;

    raid_enemies = [];
    raid_bullets = [];
    raid_doors = [];

    raid.mode = RaidMode.RESULT;

    menu_index = 0;
}