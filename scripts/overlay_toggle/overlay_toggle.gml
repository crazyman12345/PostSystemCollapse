function overlay_toggle(_mode)
{
    // Closing the currently open overlay
    if (overlay_mode == _mode)
    {
        overlay_close();
        return;
    }

    // Close/reset whatever was previously open
    overlay_close();

    // Open the new one
    overlay_open(_mode);
}