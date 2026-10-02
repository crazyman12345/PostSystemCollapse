function draw_raid_footer()
{
    switch (raid.mode)
    {


        case RaidMode.START:
        {
            terminal_prompt(
                "WASD: MOVE    LMB: SHOOT    U: LOADOUT"
            );

            break;
        }



        case RaidMode.RESULT:
        {
            terminal_prompt(
                "ENTER: CONTINUE"
            );

            break;
        }
    }
}