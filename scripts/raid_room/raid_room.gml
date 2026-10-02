function raid_room(_key, _name, _description, _x, _y, _connections, _actions)
{
    return {
        key: _key,
        name: _name,
        map_x: _x,
        map_y: _y,
		description: _description,
        connections: _connections,
        actions: _actions
    };
}