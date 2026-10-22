function raid_activate_checkpoint(_boss_door = false)
{
    raid.current_room_type = RaidRoomType.CHECKPOINT;
	quest_event(QuestObjectiveType.VISIT_LOCATION, "CHECKPOINT", 1);

    raid.extract_active = true;
    raid.doors_active = false;

    raid_doors = [];

    if (onboarding_first_quest_active()) return;

    raid_create_next_doors(true, _boss_door);
}
