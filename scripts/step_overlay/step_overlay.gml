function step_overlay()
{
    switch (overlay_mode)
    {
        case OverlayMode.SKILLS:
           step_skills_overlay();
            break;

        case OverlayMode.CREW_SKILLS:
            step_crew_skills_overlay();
            break;

        case OverlayMode.LOADOUT:
            step_loadout_overlay();
            break;

        case OverlayMode.INVENTORY:
            step_inventory_overlay();
            break;
    }
}