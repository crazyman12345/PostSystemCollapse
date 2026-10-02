function crew_skill_add_xp(_crew_index, _skill_key, _amount)
{
    // Make sure crew index is valid
    if (
        _crew_index < 0
        || _crew_index >= array_length(crew)
    )
    {
        return false;
    }


    var member =
        crew[_crew_index];


    // Make sure the crew member has this skill
    if (!variable_struct_exists(
        member.skills,
        _skill_key
    ))
    {
        return false;
    }


    var skill =
        variable_struct_get(
            member.skills,
            _skill_key
        );


    // Add XP
    skill.xp += _amount;


    // Check for level ups
    while (
        skill.xp
        >= skill_xp_required(skill.level)
    )
    {
        var required =
            skill_xp_required(
                skill.level
            );

        skill.xp -= required;

        skill.level++;


        // Get display name
        var skill_def =
            skill_get(
                _skill_key
            );


        log_add(
            member.name
            + "'s "
            + skill_def.name
            + " increased to level "
            + string(skill.level)
            + "."
        );
    }


    // Save skill back to member
    variable_struct_set(
        member.skills,
        _skill_key,
        skill
    );


    // Save member back to crew array
    crew[_crew_index] =
        member;


    return true;
}