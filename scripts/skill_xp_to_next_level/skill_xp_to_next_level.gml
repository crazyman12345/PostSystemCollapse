function skill_xp_to_next_level(_level)
{
    return skill_xp_for_level(_level + 1) - skill_xp_for_level(_level);
}