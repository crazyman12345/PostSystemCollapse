function player_skill_add_xp(_skill_key, _amount)
{
    if (!variable_struct_exists(player_skills, _skill_key))
        return false;
    var skill =
        variable_struct_get(
            player_skills,
            _skill_key
        );
    skill.xp += _amount;
    while (
        skill.xp
        >= skill_xp_required(skill.level)
    )
    {
        skill.xp -=
            skill_xp_required(
                skill.level
            );
        skill.level++;
        log_add(
            skill_db_get(_skill_key).name
            + " increased to level "
            + string(skill.level)
            + "."
        );
    }
    variable_struct_set(
        player_skills,
        _skill_key,
        skill
    );
    return true;
}