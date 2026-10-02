function workshop_get_function_count(_key)
{
    //show_debug_message("FUNCTION COUNT KEY: " + string(_key));

    switch (_key)
    {
        case "salvage_bench":
        {
            var items = workshop_get_salvageable_items();
            //show_debug_message("SALVAGEABLE ITEMS: " + string(array_length(items)));
            return array_length(items);
        }

        default:
            //show_debug_message("NO FUNCTION CASE FOR: " + string(_key));
            return 0;
    }
}