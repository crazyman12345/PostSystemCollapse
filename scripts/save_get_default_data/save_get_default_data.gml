function save_get_default_data()
{
    var was_ready = save_ready;
    save_ready = false;
    save_reset_to_defaults();
    var data = save_collect_data();
    save_ready = was_ready;
    return data;
}

function save_reset_to_defaults()
{
    init_flag_database();
    init_skill_database();
    init_workbench_database();
    init_inventory();

    var member = crew[0];
    member.hp = 100;
    member.max_hp = 100;
    member.status = CrewStatus.READY;
    member.injury_end_time = 0;
    member.weapon = "";
    member.weapon_2 = "";
    member.armor_chest = "";
    member.armor_head = "";
    member.bag = "";
    member.secure_container = "small_container";
    member.alive = true;
    crew[0] = member;
    save_unfinished_raid = false;
}
