function step_crew_skills_overlay()
{
    if (keyboard_check_pressed(ord("W")))
    {
        crew_skills_index--;
        if (crew_skills_index < 0)
        {
            crew_skills_index =
                array_length(
                    crew_skill_keys
                ) - 1;
        }
    }
    if (keyboard_check_pressed(ord("S")))
    {
        crew_skills_index++;

        if (
            crew_skills_index
            >= array_length(
                crew_skill_keys
            )
        )
        {
            crew_skills_index = 0;
        }
    }
    if (keyboard_check_pressed(ord("A")))
    {
        crew_skills_crew_index--;

        if (crew_skills_crew_index < 0)
        {
            crew_skills_crew_index =
                array_length(crew) - 1;
        }
    }
    if (keyboard_check_pressed(ord("D")))
    {
        crew_skills_crew_index++;

        if (
            crew_skills_crew_index
            >= array_length(crew)
        )
        {
            crew_skills_crew_index = 0;
        }
    }
}