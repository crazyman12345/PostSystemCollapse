function raid_location_get_all_keys(){
	 return variable_struct_get_names(
        global.raid_locations
    );
}