function save_migrate_data(_data)
{
    if (!is_struct(_data)) return undefined;
    var version = variable_struct_exists(_data, "version") ? _data.version : 0;
    if (!is_real(version) || version < 0 || version > save_format_version) return undefined;

    while (version < save_format_version)
    {
        switch (version)
        {
            case 0:
                _data.version = 1;
                if (!variable_struct_exists(_data, "meta")) _data.meta = { unfinished_raid: false };
                version = 1;
                break;

            case 1:
                _data.version = 2;
                if (!variable_struct_exists(_data, "health")) _data.health = {};
                version = 2;
                break;

			case 2:
				_data.version = 3;
				if (!variable_struct_exists(_data, "quests")) _data.quests = {};
				version = 3;
				break;

			case 3:
				_data.version = 4;
				if (!variable_struct_exists(_data, "dialogue")) _data.dialogue = {};
				version = 4;
				break;

			case 4:
				_data.version = 5;
				if (!variable_struct_exists(_data, "progression") || !is_struct(_data.progression)) _data.progression = {};
				if (!variable_struct_exists(_data.progression, "flags") || !is_struct(_data.progression.flags)) _data.progression.flags = {};
				_data.progression.flags.story_intro_complete = true;
				_data.progression.flags.starting_crate_claimed = true;
				version = 5;
				break;

            case 5:
                _data.version = 6;
                if (!variable_struct_exists(_data, "player") || !is_struct(_data.player)) _data.player = {};
                if (!variable_struct_exists(_data.player, "crew") || !is_struct(_data.player.crew)) _data.player.crew = {};
                if (!variable_struct_exists(_data.player.crew, "name")) _data.player.crew.name = "ROOK";
                version = 6;
                break;

            case 6:
                _data.version = 7;
                if (!variable_struct_exists(_data, "black_market")) _data.black_market = {};
                version = 7;
                break;

            default:
                return undefined;
        }
    }

    return _data;
}
