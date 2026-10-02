function draw_raid_combat_actions()
{
    terminal_panel(
        660,
        650,
        600,
        220,
        "COMBAT ACTION"
    );


    var actions =
    [
        "ATTACK",
        "USE ITEM"  
    ];


    for (
        var i = 0;
        i < array_length(actions);
        i++
    )
    {
        var text =
            actions[i];


        if (
            i == CombatAction.ATTACK
            && raid_is_overencumbered()
        )
        {
            text +=
                " [OVERENCUMBERED]";
        }


        terminal_menu_item(
            720,
            710 + (i * 50),
            text,
            raid.combat_action_index == i
        );
    }
}