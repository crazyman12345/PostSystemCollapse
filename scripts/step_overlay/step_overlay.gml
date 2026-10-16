function step_overlay()
{
    switch (overlay_mode)
    {
        case OverlayMode.SKILLS:
           step_skills_overlay();
            break;

        case OverlayMode.LOADOUT:
            step_loadout_overlay();
            break;

    }
}