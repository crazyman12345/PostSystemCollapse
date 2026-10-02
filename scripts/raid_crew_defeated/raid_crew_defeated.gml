function raid_crew_defeated()
{
    var member =
        crew[raid.crew_index];

    member.status =
        CrewStatus.CRITICALLY_INJURED;


    // Example: 5 minute recovery
    member.injury_end_time =
        current_time
        + (5 * 60 * 1000);


    crew[raid.crew_index] =
        member;


    // Lose everything collected during raid
    raid.bag = {};


    raid.active = false;

    log_add(
        member.name
        + " was critically injured."
    );


    game_state =
        GameState.HIDEOUT;
}