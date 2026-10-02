function step_crew_screen()
{
	  if (keyboard_check_pressed(vk_escape)){
		   
        state = GameState.HIDEOUT;
		return;
    }
	
    if (keyboard_check_pressed(ord("W")))
    {
        crew_screen_index--;

        if (crew_screen_index < 0)
        {
            crew_screen_index =
                array_length(crew) - 1;
        }
    }

    if (keyboard_check_pressed(ord("S")))
    {
        crew_screen_index++;

        if (
            crew_screen_index
            >= array_length(crew)
        )
        {
            crew_screen_index = 0;
        }
    }


    crew_update_injury(
        crew_screen_index
    );


    if (
        keyboard_check_pressed(ord("R"))
    )
    {
        crew_pay_for_treatment(
            crew_screen_index
        );
    }


  
}