function workshop_function_interact(_key)
{
    var bench = variable_struct_get(workshop_db, _key);
    var level = variable_struct_get(workshop_progress, _key);

    if (level <= 0)
    {
        log_add("You need to build the " + bench.name + " first.");
        return;
    }

    switch (_key)
    {
        case "salvage_bench":
            workshop_salvage_interact();
        break;

        case "workbench":
            workshop_crafting_interact(_key);
        break;

        case "medical_station":
            workshop_crafting_interact(_key);
        break;

        case "drug_station":
            workshop_crafting_interact(_key);
        break;

        case "armor_bench":
            workshop_crafting_interact(_key);
        break;
    }
}