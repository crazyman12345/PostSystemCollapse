function raid_roll_threat_encounter()
{
    if (raid.threat_level <= 0)
        return false;


    var encounter_chance =
        raid_get_threat_encounter_chance();


    if (random(100) >= encounter_chance)
        return false;


    return true;
}