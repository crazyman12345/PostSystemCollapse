function crew_pay_for_treatment(_crew_index)
{
    var treatment_cost = 50;

    var member =
        crew[_crew_index];


    if (
        member.status
        != CrewStatus.CRITICALLY_INJURED
    )
    {
        return false;
    }
	var money = inventory_get_quantity("cash");

    if (money < treatment_cost)
    {
        log_add(
            "Not enough money."
        );

        return false;
    }


    inventory_remove("cash", treatment_cost);


    member.status =
        CrewStatus.READY;

    member.injury_end_time = 0;


    crew[_crew_index] =
        member;


    log_add(
        member.name
        + " has been treated."
    );


    return true;
}