function raid_activate_checkpoint()
{
    raid.current_room_type = RaidRoomType.CHECKPOINT;

    raid.extract_active = true;
    raid.doors_active = false;

    raid_doors = [];

    raid_create_next_doors();
}