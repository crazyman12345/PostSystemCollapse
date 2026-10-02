function skill_get_level(_key)
{
    if (!variable_struct_exists(player_skills, _key)) return 1;

    var skill = variable_struct_get(player_skills, _key);
    return skill.level;
}