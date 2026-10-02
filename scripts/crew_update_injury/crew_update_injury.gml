function crew_update_injury(_crew_index)
{
    var member =
        crew[_crew_index];


    if (
        member.status
        == CrewStatus.CRITICALLY_INJURED
    )
    {
        if (
            current_time
            >= member.injury_end_time
        )
        {
            member.status =
                CrewStatus.READY;

            member.injury_end_time = 0;

            crew[_crew_index] =
                member;
        }
    }
}