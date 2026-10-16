function workshop_function_interact(_key)
{
    var level = variable_struct_get(workshop_progress, _key);

    if (level <= 0)
    {
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
