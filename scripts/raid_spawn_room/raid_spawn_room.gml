function raid_spawn_room()
{
    raid_enemies = [];
    raid_bullets = [];

    raid.room_cleared = false;

    raid_spawn_enemy(550, 300);
    raid_spawn_enemy(960, 250);
    raid_spawn_enemy(1350, 350);
}