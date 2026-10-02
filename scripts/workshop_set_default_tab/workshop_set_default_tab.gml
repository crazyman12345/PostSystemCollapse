function workshop_set_default_tab()
{
    var key = workshop_keys[workshop_station_index];
    var level = variable_struct_get(workshop_progress, key);

    if (level > 0)
    {
        workshop_tab = WorkshopTab.FUNCTION;
        workshop_focus = WorkshopFocus.CONTENT;
    }
    else
    {
        workshop_tab = WorkshopTab.UPGRADES;
        workshop_focus = WorkshopFocus.STATIONS;
    }

    workshop_content_index = 0;
}