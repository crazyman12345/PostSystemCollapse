function step_skills_overlay()
{
    if (keyboard_check_pressed(ord("W")))
    {
        skills_index--;

        if (skills_index < 0)
        {
            skills_index =
                array_length(
                    player_skill_keys
                ) - 1;
        }
    }

    if (keyboard_check_pressed(ord("S")))
    {
        skills_index++;

        if (
            skills_index
            >= array_length(
                player_skill_keys
            )
        )
        {
            skills_index = 0;
        }
    }
}