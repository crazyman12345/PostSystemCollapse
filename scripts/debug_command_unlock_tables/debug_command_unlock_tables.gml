function debug_command_unlock_tables(){
	for (var i = 0; i < array_length(workshop_keys); i++)
	    {
	        var key = workshop_keys[i];
			var level = variable_struct_set(workshop_progress, key, 1);
		}
}